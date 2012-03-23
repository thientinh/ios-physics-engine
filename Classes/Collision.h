//
//  Collision.h
//  Falling Bricks
//
//  Created by eLdwin on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Shape;
@class Vector2D;

@interface Collision : NSObject {

}

+ (Collision*)collisionWithShape1:(Shape*)one shape2:(Shape*)two;
// EFFECTS: Inits with only the two shapes

- (BOOL)testCollision;
// EFFECTS: Returns YES if shape1 collides with shape2

- (NSArray*)findContactPoints;
// REQUIRES: testCollision returns YES
// EFFECTS: Returns an array of contact points

@end
