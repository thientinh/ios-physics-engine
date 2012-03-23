//
//  RectangleRectangleCollision.m
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RectangleRectangleCollision.h"

#import "Shape.h"
#import "Rectangle.h"

#import "Vector2D.h"
#import "Matrix2D.h"

#import "Contact.h"
#import "Collision.h"

@implementation RectangleRectangleCollision

@synthesize rect1;
@synthesize rect2;

- (id)initWithRectangle1:(Rectangle*)one rectangle2:(Rectangle*)two {
  if (self = [super init]) {
    [self setRect1:one];
    [self setRect2:two];
  }
  return self;
}

- (BOOL)testCollision {
  
  if (!CGRectIntersectsRect(rect1.axisAlignedBoundingBox, rect2.axisAlignedBoundingBox))
    return NO;
  
  pA = [rect1.center retain];
  pB = [rect2.center retain];
  
  hA = [rect1.halfVector retain];
  hB = [rect2.halfVector retain];
  
  Ra = [rect1.coordinateMatrix retain];
  Rb = [rect2.coordinateMatrix retain];
  
  RaT = [[Ra transpose] retain];
  RbT = [[Rb transpose] retain];
  Matrix2D* C = [RaT multiply:Rb];
  
  // direction vector from center of A to center of B
  Vector2D* d = [pB subtract:pA];
  dA = [[RaT multiplyVector:d] retain]; // in shape1's coordinate system
  dB = [[RbT multiplyVector:d] retain]; // in shape2's coordinate system

  Vector2D* fA = [[[dA abs] subtract:hA] subtract:[[C abs] multiplyVector:hB]];
  Vector2D* fB = [[[dB abs] subtract:hB] subtract:[[[C transpose] abs] multiplyVector:hA]];
  
  fAB[0] = fA.x;
  fAB[1] = fA.y;
  fAB[2] = fB.x;
  fAB[3] = fB.y;
  
  //return (fA.x < 0 && fA.y < 0 && fB.x < 0 && fB.y < 0);
  return !(fA.x > 0 || fA.y > 0 || fB.x > 0 || fB.y > 0);  
}

- (NSArray*)findContactPoints {
  
  // look for largest value from fA.x, fA.y, fB.x, fB.y to decide which rect to use as reference
  int index = 0;
  double largest = fAB[0];
  for (int i = 1; i < 4; i++) {
    if (fAB[i] > largest) {
      index = i;
      largest = fAB[i];
    }
  }
  
  Vector2D *n, *nf, *ns;
  double Df, Ds, Dneg, Dpos;
  
  switch (index) {
    case 0: // ax
      n = (dA.x > 0) ? Ra.col1 : [Ra.col1 negate];
      nf = n;
      Df = [pA dot:nf] + hA.x;
      ns = Ra.col2;
      Ds = [pA dot:ns];
      Dneg = hA.y - Ds;
      Dpos = hA.y + Ds;
      break;
      
    case 1: // ay
      n = (dA.y > 0) ? Ra.col2 : [Ra.col2 negate];
      nf = n;
      Df = [pA dot:nf] + hA.y;
      ns = Ra.col1;
      Ds = [pA dot:ns];
      Dneg = hA.x - Ds;
      Dpos = hA.x + Ds;
      break;
      
    case 2: // bx
      n = (dB.x > 0) ? Rb.col1 : [Rb.col1 negate];
      nf = [n negate];
      Df = [pB dot:nf] + hB.x;
      ns = Rb.col2;
      Ds = [pB dot:ns];
      Dneg = hB.y - Ds;
      Dpos = hB.y + Ds;
      break;
      
    case 3: // by
      n = (dB.y > 0) ? Rb.col2 : [Rb.col2 negate];
      nf = [n negate];
      Df = [pB dot:nf] + hB.y;
      ns = Rb.col1;
      Ds = [pB dot:ns];
      Dneg = hB.x - Ds;
      Dpos = hB.x + Ds;
      break;
  }
  
  Vector2D *ni, *p, *h;
  Matrix2D* R;
  
  if (index < 2) {
    ni = [[RbT multiplyVector:nf] negate];
    p = pB;
    R = Rb;
    h = hB;
  }
  else {
    ni = [[RaT multiplyVector:nf] negate];
    p = pA;
    R = Ra;
    h = hA;
  }
  
  Vector2D *v1, *v2;
  Vector2D* niAbs = [ni abs];
  if (niAbs.x > niAbs.y) {
    if (ni.x > 0) {
      v1 = [p add:[R multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
      v2 = [p add:[R multiplyVector:h]];
    }
    else {
      v1 = [p add:[R multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
      v2 = [p add:[R multiplyVector:[h negate]]];
    }
  }
  else {
    if (ni.y > 0) {
      v1 = [p add:[R multiplyVector:h]];
      v2 = [p add:[R multiplyVector:[Vector2D vectorWith:-h.x y:h.y]]];
    }
    else {
      v1 = [p add:[R multiplyVector:[h negate]]];
      v2 = [p add:[R multiplyVector:[Vector2D vectorWith:h.x y:-h.y]]];
    }
  }
  
  double dist1 = [[ns negate] dot:v1] - Dneg;
  double dist2 = [[ns negate] dot:v2] - Dneg;
  
  if (dist1 < 0 && dist2 > 0) {
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  }
  else if (dist1 > 0 && dist2 < 0) {
    Vector2D* temp = v1;
    v1 = v2;
    v2 = [temp add:[[v2 subtract:temp] multiply:(dist1 / (dist1 - dist2))]];
  }
  
  dist1 = [ns dot:v1] - Dpos;
  dist2 = [ns dot:v2] - Dpos;
  
  if (dist1 < 0 && dist2 > 0) {
    v2 = [v1 add:[[v2 subtract:v1] multiply:(dist1 / (dist1 - dist2))]];
  }
  else if (dist1 > 0 && dist2 < 0) {
    Vector2D* temp = v1;
    v1 = v2;
    v2 = [temp add:[[v2 subtract:temp] multiply:(dist1 / (dist1 - dist2))]];
  }
  
  double s1, s2;
  Vector2D *c1, *c2;
  
  s1 = [nf dot:v1] - Df;
  c1 = [v1 subtract:[nf multiply:s1]];
  s2 = [nf dot:v2] - Df;
  c2 = [v2 subtract:[nf multiply:s2]];
  
  NSMutableArray* contactPoints = [NSMutableArray array];
  
  if (s1 < 0) {
    Contact* contact = [[Contact alloc] initWithShape1:self.rect1 shape2:self.rect2 point:c1 normal:n separation:s1];
    [contactPoints addObject:contact];
    [contact release];
  }
  if (s2 < 0) {
    Contact* contact = [[Contact alloc] initWithShape1:self.rect1 shape2:self.rect2 point:c2 normal:n separation:s2];
    [contactPoints addObject:contact];
    [contact release];
  }
  
  return contactPoints;
}

- (void)dealloc {
  [dA release];
  [dB release];
  [pA release];
  [pB release];
  [hA release];
  [hB release];
  [Ra release];
  [Rb release];
  [RaT release];
  [RbT release];
  
  [self setRect1:nil];
  [self setRect2:nil];
  
  [super dealloc];
}

@end
