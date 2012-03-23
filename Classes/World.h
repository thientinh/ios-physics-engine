//
//  World.h
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Shape.h"

@class Contact;
@class Vector2D;

@interface World : NSObject {

@private
  float timeStep;
  int impulseIterations;
  
  Vector2D* gravity;
  NSMutableArray* shapes;
  
  // cache
  NSMutableArray* contacts;
  NSMutableArray* collisions;
}

@property (nonatomic, assign) float timeStep;
@property (nonatomic, assign) int impulseIterations;

@property (nonatomic, retain) Vector2D* gravity;
@property (nonatomic, retain) NSMutableArray* shapes;


- (id)init;
// EFFECTS: Inits world with default settings 

- (id)createShape:(ShapeType)type;

- (void)addShape:(Shape*)shape;
// EFFECTS: Given body is added to simulator

- (void)removeShape:(Shape*)shape;
// EFFECTS: Given body is removed from simulator

- (void)simulateTimeStep:(float)delta;
// EFFECTS: Advance the simulation by delta

- (void)applyImpulses:(float)delta;
// EFFECTS: Resolve and apply all impulses from list of collisions
  
- (void)applyExternalForces:(float)delta;
// EFFECTS: External forces such as gravity and damping functions applied to each body

- (void)applyImpulse:(Contact*)c delta:(float)delta;
// EFFECTS: Applies impulse to two colliding objects

- (void)updatePositionsAndRotations:(float)delta;
  // update positions and velocities
  
- (void)findAllCollisions;
// EFFECTS: Finds all unique pairs of colliding objects and adds them into NSMutableArray* collisions

- (void)dealloc;

@end
