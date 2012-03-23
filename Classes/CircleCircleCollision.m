//
//  CircleCircleCollision.m
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CircleCircleCollision.h"

#import "Circle.h"
#import "Vector2D.h"

#import "Contact.h"
#import "Collision.h"

@implementation CircleCircleCollision

@synthesize circle1;
@synthesize circle2;
@synthesize oneToTwo;

- (id)initWithCircle1:(Circle*)one circle2:(Circle*)two {
  if (self = [super init]) {
    [self setCircle1:one];
    [self setCircle2:two];
    [self setOneToTwo:[circle2.center subtract:circle1.center]];
  }
  return self;
}

- (BOOL)testCollision {
  distance = self.oneToTwo.length;
  separation = distance - circle1.radius - circle2.radius;
  return (separation < 0);
}

- (NSArray*)findContactPoints {
  Vector2D* point = [circle1.center add:[oneToTwo multiply:(circle1.radius / distance)]];
  oneToTwo = [[oneToTwo multiply:1.0/distance] retain];
  Contact* contact = [[Contact alloc] initWithShape1:circle1 shape2:circle2 point:point normal:oneToTwo separation:separation];
  NSArray* contactPoints = [NSArray arrayWithObject:contact];
  [contact release];
  return contactPoints;
}

- (void)dealloc {
  [self setCircle1:nil];
  [self setCircle2:nil];
  [self setOneToTwo:nil];
  [super dealloc];
}


@end
