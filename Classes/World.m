//
//  World.m
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "World.h"

#import "Shape.h"
#import "Vector2D.h"
#import "Matrix2D.h"

#import "Contact.h"
#import "Collision.h"


@implementation World

const double E = 0.2;
const double k = 0.01;
const double N = 0.95;
const double GRAVITY = -98.1;
const int NO_OF_ITERATIONS = 2;

// estimates
const int NO_OF_OBJECTS = 100;

@synthesize shapes;
@synthesize gravity;
@synthesize timeStep;
@synthesize impulseIterations;

- (id)init {
  if (self = [super init]) {
    [self setShapes:[NSMutableArray array]];
    [self setImpulseIterations:NO_OF_ITERATIONS];
    [self setGravity:[Vector2D vectorWith:0.0 y:GRAVITY]];
    
    collisions = [[NSMutableArray arrayWithCapacity:NO_OF_OBJECTS] retain];
    contacts = [[NSMutableArray arrayWithCapacity:NO_OF_OBJECTS * 2] retain];
  }
  return self;
}

- (id)createShape:(ShapeType)type {
  return [Shape shapeWithType:type];
}

- (void)addShape:(Shape*)shape {
  [[self shapes] addObject:shape];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShapeAdded" object:self userInfo:nil];
}

- (void)removeShape:(Shape*)shape {
  [[self shapes] removeObject:shape];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShapeRemoved" object:self userInfo:nil];
}

- (void)applyExternalForces:(float)delta {
  // EFFECTS: Applies external forces acting on the bodies such as gravity and damping functions
  
  for (Shape* shape in [self shapes]) {
    
    // objects that can't move only get collided into
    if (!shape.canMove)
      continue;
    
    // gravity
    [shape setVelocity:[shape.velocity add:[self.gravity multiply:delta]]];
    
    // TODO: damping functions
  }
}

- (void)updatePositionsAndRotations:(float)delta {
  // update positions and rotations
  for (Shape* shape in [self shapes]) {
    
    // objects that can't move only get collided into
    if (!shape.canMove)
      continue;
    
    [shape setRotation:(shape.rotation + (shape.angularVelocity * delta))];
    [shape setPosition:[shape.position add:[shape.velocity multiply:delta]]];
  }
}

- (void)applyImpulses:(float)delta {
  // EFFECTS: Resolve and apply all impulses from list of collisions
  
  for (int i = 0; i < [self impulseIterations]; i++) {
    for (Contact* c in contacts) {
      [self applyImpulse:c delta:delta];
      
      /*
      UIView* contact = [[[UIView alloc] init] autorelease];
      [contact setBackgroundColor:[UIColor blackColor]];
      [contact setAlpha:0.5];
      [contact setFrame:CGRectMake(c.point.x-10, 1004-(c.point.y-10), 20, 20)];
      [[[UIApplication sharedApplication] keyWindow] addSubview:contact];
      [UIView animateWithDuration:0.5 animations:^{contact.alpha = 0.0;} completion:^(BOOL finished){[contact removeFromSuperview];}];
      */
    }
  }
}


- (void)findAllCollisions {
  // EFFECTS: Returns all unique pairs of colliding objects
  
  for (int i = 0; i < self.shapes.count; i++) {
    
    Shape* one = [self.shapes objectAtIndex:i];
    
    if (!one.canMove)
      continue;
    
    for (int j = 0; j < self.shapes.count; j++) {
      
      if (i == j)
        continue;
      
      Shape* two = [self.shapes objectAtIndex:j];
      
      if (j < i && two.canMove)
        continue;
      
      // collide only against all non-moving objects and those after itself in the array
      Collision* pair = [Collision collisionWithShape1:one shape2:two];
      if ([pair testCollision]) {
        [collisions addObject:pair];
      }
    }
  }
}

- (void)simulateTimeStep:(float)delta {
  // EFFECTS: Advance the simulation by delta
  
  // apply gravity and damping
  [self applyExternalForces:delta];
  
  // find all unique pairs of collisions
  [self findAllCollisions];
  
  // find all contact points
  for (Collision* c in collisions) {
    NSArray* points = [c findContactPoints];
    [contacts addObjectsFromArray:points];
  }
  
  // apply impulses to all contact points
  [self applyImpulses:delta];

  // update positions and rotations
  [self updatePositionsAndRotations:delta];

  // clear cache
  [contacts removeAllObjects];
  [collisions removeAllObjects];
}


- (void)applyImpulse:(Contact*)c delta:(float)delta {
  // EFFECTS: Applies impulse to two colliding objects
  
  Shape* a = c.shape1;
  Shape* b = c.shape2;
  Vector2D* n = c.normal;
  
  Vector2D* rA = [c.point subtract:a.center];
  Vector2D* rB = [c.point subtract:b.center];
  
  Vector2D* uA = [a.velocity subtract:[rA crossZ:a.angularVelocity]];
  Vector2D* uB = [b.velocity subtract:[rB crossZ:b.angularVelocity]];
  Vector2D* u = [uB subtract:uA];
  
  Vector2D* t = [n crossZ:1];
  double un = [u dot:n];
  double ut = [u dot:t];
  
  double rAdotrA = [rA dot:rA];
  double rBdotrB = [rB dot:rB];
  double massn = 1.0 / (a.invMass + b.invMass + ((rAdotrA - pow([rA dot:n], 2)) / a.inertia) + ((rBdotrB - pow([rB dot:n], 2)) / b.inertia));
  double masst = 1.0 / (a.invMass + b.invMass + ((rAdotrA - pow([rA dot:t], 2)) / a.inertia) + ((rBdotrB - pow([rB dot:t], 2)) / b.inertia));
  
  double bias = (k < fabs(c.separation)) ? fabs((E / delta) * (k + c.separation)) : 0.0;
  
  Vector2D* Pn = [n multiply:(massn * (un - bias))];
  double dPt = ut * masst;
  double Ptmax = a.friction * b.friction * Pn.length;
  dPt = MAX(-Ptmax, MIN(dPt, Ptmax));
  Vector2D* Pt = [t multiply:dPt];
  
  Vector2D* PnPlusPt = [Pn add:Pt];
  
  if (a.canMove) {
    [a setVelocity:[a.velocity add:[PnPlusPt multiply:a.invMass]]];
    a.angularVelocity += [[rA multiply:a.invInertia] cross:PnPlusPt];
  }
  
  if (b.canMove) {
    [b setVelocity:[b.velocity subtract:[PnPlusPt multiply:b.invMass]]];
    b.angularVelocity -= [[rB multiply:b.invInertia] cross:PnPlusPt];
  }
}

- (void)dealloc {
  [contacts release];
  [collisions release];
  
  [self setShapes:nil];
  [self setGravity:nil];
  [super dealloc];
}

@end
