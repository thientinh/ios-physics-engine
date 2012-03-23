//
//  RectangleCircleCollision.m
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RectangleCircleCollision.h"

#import "Circle.h"
#import "Rectangle.h"

#import "Vector2D.h"
#import "Matrix2D.h"

#import "Contact.h"


@implementation RectangleCircleCollision


@synthesize rect;
@synthesize circle;


- (id)initWithRectangle:(Rectangle*)r circle:(Circle*)c {
  if (self = [super init]) {
    [self setRect:r];
    [self setCircle:c];
  }
  return self;
}


- (BOOL)testCollision {
  
  if (!CGRectIntersectsRect(rect.axisAlignedBoundingBox, circle.axisAlignedBoundingBox))
    return NO;
  
  circleCenter = [circle.center retain];
  rectHalfVector = [rect.halfVector retain];  
  rectToCircle = [[circleCenter subtract:rect.center] retain];
  circleCenterInRectCoord = [[[rect transitionMatrix] multiplyVector:rectToCircle] retain];
  
  // center of circle has to be within rectangle + "fence" with circle's radius
  Vector2D* bounds = [rectHalfVector add:circle.halfVector];
  
  Vector2D* absCircleCenterInRectCoord = [circleCenterInRectCoord abs];
  
  // center of circle totally outside bounds
  if (absCircleCenterInRectCoord.x > bounds.x || absCircleCenterInRectCoord.y > bounds.y)
    return NO;
  
  if (absCircleCenterInRectCoord.x > rectHalfVector.x)
    horizontalCollision = YES;
  
  if (absCircleCenterInRectCoord.y > rectHalfVector.y)
    verticalCollision = YES;
  
  // center of circle within bounds but top right corner is an exception
  // circle is not touching rect unless its distance from center to topright of rect is < radius
  if (horizontalCollision && verticalCollision) {
    return ([[absCircleCenterInRectCoord subtract:rectHalfVector] length] < circle.radius);
  }
  
  return YES;
}

- (NSArray*)findContactPoints {
  
  Matrix2D* rectCoord = [rect coordinateMatrix];
  
  double sep;
  Vector2D *n;
  Vector2D* collisionPoint;
  
  NSMutableArray* contactPoints = [NSMutableArray array];
  
  if (horizontalCollision && verticalCollision) {
    if (circleCenterInRectCoord.x > 0) {
      if (circleCenterInRectCoord.y > 0) { // top-right quadrant
        collisionPoint = [rect cornerFrom:kTopRightCorner];
      }
      else { // bottom-right quadrant
        collisionPoint = [rect cornerFrom:kBottomRightCorner];
      }
    }
    else {
      if (circleCenterInRectCoord.y > 0) { // top-left quadrant
        collisionPoint = [rect cornerFrom:kTopLeftCorner];
      }
      else { // bottom-left quadrant
        collisionPoint = [rect cornerFrom:kBottomLeftCorner];
      }
    }
    
    Vector2D* cornerToCircleCenter = [circleCenter subtract:collisionPoint];
    sep = circle.radius - cornerToCircleCenter.length;
    n = cornerToCircleCenter;
  }
  else if (horizontalCollision) {
    sep = circle.radius + rectHalfVector.x - [circleCenterInRectCoord abs].x;
    if (circleCenterInRectCoord.x > 0) {
      n = rectCoord.col1;
      collisionPoint = [rectCoord multiplyVector:[Vector2D vectorWith:rectHalfVector.x y:circleCenterInRectCoord.y]];
    }
    else {
      n = [rectCoord.col1 negate];
      collisionPoint = [rectCoord multiplyVector:[Vector2D vectorWith:-rectHalfVector.x y:circleCenterInRectCoord.y]];
    }
    
    collisionPoint = [collisionPoint add:rect.center];
  }
  else {
    sep = circle.radius + rectHalfVector.y - [circleCenterInRectCoord abs].y;
    if (circleCenterInRectCoord.y > 0) {
      n = rectCoord.col2;
      collisionPoint = [rectCoord multiplyVector:[Vector2D vectorWith:circleCenterInRectCoord.x y:rectHalfVector.y]];
    }
    else {
      n = [rectCoord.col2 negate];
      collisionPoint = [rectCoord multiplyVector:[Vector2D vectorWith:circleCenterInRectCoord.x y:-rectHalfVector.y]];
    }
    
    collisionPoint = [collisionPoint add:rect.center];
  }

  // normalize
  n = [n multiply:(1.0/n.length)];
  
  Contact* contact = [[Contact alloc] initWithShape1:rect shape2:circle point:collisionPoint normal:n separation:sep];
  [contactPoints addObject:contact];
  [contact release];
  return contactPoints;
}

- (void)dealloc {
  [circleCenter release];
  [rectToCircle release];
  [rectHalfVector release];
  [super dealloc];
}
      
@end
