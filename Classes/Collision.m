//
//  Collision.m
//  Falling Bricks
//
//  Created by eLdwin on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Collision.h"

#import "Shape.h"
#import "Circle.h"
#import "Rectangle.h"
#import "CircleCircleCollision.h"
#import "RectangleCircleCollision.h"
#import "RectangleRectangleCollision.h"

@implementation Collision


+ (Collision*)collisionWithShape1:(Shape*)one shape2:(Shape*)two {
  
  if (one.type == kCircleShape && two.type == kCircleShape)
    return [[[CircleCircleCollision alloc] initWithCircle1:(Circle*)one circle2:(Circle*)two] autorelease];
  
  if (one.type == kRectangleShape && two.type == kRectangleShape)
    return [[[RectangleRectangleCollision alloc] initWithRectangle1:(Rectangle*)one rectangle2:(Rectangle*)two] autorelease];
    
  if (one.type == kCircleShape && two.type == kRectangleShape)
    return [[[RectangleCircleCollision alloc] initWithRectangle:(Rectangle*)two circle:(Circle*)one] autorelease];
  
  if (one.type == kRectangleShape && two.type == kCircleShape)
    return [[[RectangleCircleCollision alloc] initWithRectangle:(Rectangle*)one circle:(Circle*)two] autorelease];
  
  [NSException raise:@"Collision::collisionWithShape1:shape2:" format:@"Collision between ShapeType %d & %d unsupported.", one.type, two.type];
  return nil;
}

- (BOOL)testCollision {
  [NSException raise:@"Collision::testCollision" format:@"Override this method in subclass"];
  return NO;
}

- (NSArray*)findContactPoints {
  [NSException raise:@"Collision::findContactPoints" format:@"Override this method in subclass"];
  return nil;
}

@end
