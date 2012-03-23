//
//  Shape2.m
//  Falling Bricks
//
//  Created by eLdwin on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shape.h"
#import "Circle.h"
#import "Rectangle.h"

#import "Vector2D.h"
#import "Matrix2D.h"

@implementation Shape

@synthesize type;

@synthesize canMove;
@synthesize canRotate;

@synthesize mass;
@synthesize friction;
@synthesize restitution;
@synthesize rotation;
@synthesize angularVelocity;

@synthesize position;
@synthesize velocity;

// cached values
@synthesize invMass;
@synthesize inertia;
@synthesize invInertia;
@synthesize halfVector;

const double TWO_PI = M_PI * 2;


- (void)setMass:(double)m {
  mass = m;
  invMass = 1.0 / mass;
  [self updateInertia];
}

- (void)setRotation:(double)r {
  
  while (ABS(r) >= TWO_PI) {
    if (r < 0.0)
      r += TWO_PI;
    else
      r -= TWO_PI;
  }
  rotation = r;
}


- (ShapeType)type {
  [NSException raise:@"Shape::type" format:@"Override this method in subclass"];
  return 0;
}


- (Vector2D*) center {
  // EFFECTS: returns the coordinates of the centre of mass for this shape.
  [NSException raise:@"Shape::center" format:@"Override this method in subclass"];
  return nil;
}

- (void)updateInertia {
  [NSException raise:@"Shape::updateInertia" format:@"Override this method in subclass"];
}

- (void)updateHalfVector {
  [NSException raise:@"Shape::updateHalfVector" format:@"Override this method in subclass"];
}

- (CGRect)axisAlignedBoundingBox {
  [NSException raise:@"Shape::axisAlignedBoundingBox" format:@"Override this method in subclass"];
  return CGRectMake(0, 0, 0, 0);
}

- (Matrix2D*)coordinateMatrix {
  // EFFECTS: returns matrix representing co-ordinate system of this rectangle
  return [Matrix2D initRotationMatrix:[self rotation]];
}

- (Matrix2D*)transitionMatrix {
  // EFFECTS: returns transition matrix from normal co-ordinate system to rect's co-ordinate system
  return [[self coordinateMatrix] transpose];
}

+ (id)shapeWithType:(ShapeType)type {
  
  switch (type) {
    case kCircleShape:
      return [[[Circle alloc] init] autorelease];
      
    case kRectangleShape:
      return [[[Rectangle alloc] init] autorelease];
      
    default:
      [NSException raise:@"Shape::shapeWithType" format:@"ShapeType is invalid"];
      return nil;
  }
}

- (id)init {
  return [self initwithMass:0 rotation:0 restitution:1 angularVelocity:0 width:0 height:0
                    canMove:YES canRotate:YES
                   position:[Vector2D vectorWith:0 y:0] velocity:[Vector2D vectorWith:0 y:0]];
}

- (id)initwithMass:(double)m rotation:(double)r restitution:(double)res angularVelocity:(double)av width:(double)w height:(double)h
           canMove:(BOOL)cm canRotate:(BOOL)cr
          position:(Vector2D*)p velocity:(Vector2D*)v {
  if (self = [super init]) {
    
    // cached values
    invMass = 0.0;
    inertia = 0.0;
    invInertia = 0.0;
    halfVector = [[Vector2D vectorWith:0.0 y:0.0] retain];
    
    [self setCanMove:cm];
    [self setCanRotate:cr];
    
    [self setMass:m];
    [self setRotation:r];
    [self setRestitution:res];
    
    [self setPosition:p];
    [self setVelocity:v];
    
    [self setAngularVelocity:av];
  }
  return self;
}

- (void)dealloc {
  [halfVector release];
  [self setPosition:nil];
  [self setVelocity:nil];
  [super dealloc];
}

@end
