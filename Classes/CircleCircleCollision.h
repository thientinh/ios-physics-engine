//
//  CircleCircleCollision.h
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Collision.h"

@class Circle;
@class Vector2D;

@interface CircleCircleCollision : Collision {

@private
  Circle* circle1;
  Circle* circle2;

// variables to carry over from collision test to contact point solving
  double separation;
  // seperation of contact points
  
  double distance;
  // distance of oneToTwo
  
  Vector2D* oneToTwo;
  // vector from center of circle1 to center of circle2
}

@property (nonatomic, retain) Circle* circle1;
@property (nonatomic, retain) Circle* circle2;
@property (nonatomic, retain) Vector2D* oneToTwo;

- (id)initWithCircle1:(Circle*)one circle2:(Circle*)two;

- (void)dealloc;

@end
