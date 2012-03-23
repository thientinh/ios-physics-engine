//
//  RectangleRectangleCollision.h
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Collision.h"

@class Shape;
@class Rectangle;

@class Vector2D;
@class Matrix2D;

@interface RectangleRectangleCollision : Collision {

@private
  Rectangle* rect1;
  Rectangle* rect2;
  
  // variables to carry over from collision test to contact point solving
  double fAB[4];
  Vector2D *dA, *dB;
  Vector2D *pA, *pB;
  Vector2D *hA, *hB;
  Matrix2D *Ra, *Rb;
  Matrix2D *RaT, *RbT;
}

@property (nonatomic, retain) Rectangle* rect1;
@property (nonatomic, retain) Rectangle* rect2;

- (id)initWithRectangle1:(Rectangle*)one rectangle2:(Rectangle*)two;

@end
