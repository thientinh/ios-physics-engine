//
//  RectangleCircleCollision.h
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Collision.h"

@class Circle;
@class Rectangle;

@interface RectangleCircleCollision : Collision {

@private
  Circle* circle;
  Rectangle* rect;

  // variables to carry over from collision test to contact point solving

  Vector2D* circleCenter;
  // vector from origin to center of circle in normal coordinate system
  
  Vector2D* rectToCircle;
  // vector from center of rectangle to center of circle
  
  Vector2D* rectHalfVector;
  
  Vector2D* circleCenterInRectCoord;
  // center of circle in rectangle's coordinate system
  
  
  
  // if verticalCollision & horizontalCollision are both YES then circle is hitting a corner of the rectangle
  BOOL verticalCollision;
  // only used when circle is colliding with rectangle
  // YES if circle is colliding with rectangle on its top or bottom faces
  
  BOOL horizontalCollision;
  // only used when circle is colliding with rectangle
  // YES if circle is colliding with rectangle on one of its left or right faces
}

@property (nonatomic, retain) Circle* circle;
@property (nonatomic, retain) Rectangle* rect;

- (id)initWithRectangle:(Rectangle*)r circle:(Circle*)c;

@end
