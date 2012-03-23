//
//  PEShape.h
//  
//  CS3217 || Assignment 1
//

#import <Foundation/Foundation.h>

typedef enum {
  kCircleShape,
  kRectangleShape
} ShapeType;

@class Vector2D;
@class Matrix2D;

@interface Shape : NSObject {
  
@private 
  BOOL canMove;
  BOOL canRotate;
  
  double mass;
  double friction;
  double restitution;
  
  // rotation in radians
  double rotation;
  // angular velocity in radians
  double angularVelocity;
  
  Vector2D* position;
  Vector2D* velocity;
  
@protected
  // cached values
  double invMass;
  double inertia;
  double invInertia;
  Vector2D* halfVector; 
}

@property (nonatomic, readonly) ShapeType type;

@property (nonatomic, assign) BOOL canMove;
@property (nonatomic, assign) BOOL canRotate;

@property (nonatomic, assign) double mass;
@property (nonatomic, assign) double friction;
@property (nonatomic, assign) double restitution;

@property (nonatomic, assign) double rotation;
@property (nonatomic, assign) double angularVelocity;

@property (nonatomic, retain) Vector2D* position;
@property (nonatomic, retain) Vector2D* velocity;

@property (nonatomic, readonly) Matrix2D* coordinateMatrix;
// EFFECTS: returns matrix representing co-ordinate system of this rectangle

@property (nonatomic, readonly) Matrix2D* transitionMatrix;
// EFFECTS: returns transition matrix from normal co-ordinate system to rect's co-ordinate system

// cached values
@property (nonatomic, readonly) double invMass;
@property (nonatomic, readonly) double inertia;
@property (nonatomic, readonly) double invInertia;
@property (nonatomic, readonly) Vector2D* halfVector;
// EFFECTS: returns vector from center to top right of shape

/*****************************************************************
  Override
 ****************************************************************/
@property (nonatomic, readonly) Vector2D* center;
// EFFECTS: returns vector from origin to center of mass of shape

@property (nonatomic, readonly) CGRect axisAlignedBoundingBox;
// EFFECTS: returns the bounding box of this shape.

- (void)updateInertia;
// EFFECTS: 

- (void)updateHalfVector;
// EFFECTS:

/*****************************************************************
 Methods
 ****************************************************************/
+ (id)shapeWithType:(ShapeType)type;

- (id)initwithMass:(double)m rotation:(double)r restitution:(double)res angularVelocity:(double)av width:(double)w height:(double)h
           canMove:(BOOL)cm canRotate:(BOOL)cr
          position:(Vector2D*)p velocity:(Vector2D*)v;

@end
