//
//  Circle.m
//  Falling Bricks
//
//  Created by eLdwin on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"
#import "Vector2D.h"


@implementation Circle


@synthesize radius;
@synthesize diameter;

- (ShapeType)type {
  return kCircleShape;
}


- (Vector2D*)center {
  // EFFECTS: returns the coordinates of the centre of mass for this circle.
  return [Vector2D vectorWith:(self.position.x + self.radius) y:(self.position.y + self.radius)];
}


- (void)updateInertia {
  inertia = 0.5 * self.mass * pow(self.radius, 2);
  invInertia = 1.0 / inertia;
}


- (void)updateHalfVector {
  halfVector = [[Vector2D vectorWith:self.radius y:self.radius] retain];
}


- (void)updateDiameter {
  diameter = self.radius * 2.0;
}


- (void)setRadius:(double)r {
  radius = r;
  [self updateInertia];
  [self updateDiameter];
  [self updateHalfVector];
}


- (CGRect)axisAlignedBoundingBox {
  // EFFECTS: returns the bounding box of this shape.
  return CGRectMake(self.position.x, self.position.y, self.diameter, self.diameter);
}


@end
