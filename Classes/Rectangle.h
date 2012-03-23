//
//  PERectangle.h
//  
//  CS3217 || Assignment 1
//  Name: Eldwin Liew
//

#import <Foundation/Foundation.h>

#import "Shape.h"

typedef enum {
	 kTopLeftCorner = 1,
	 kTopRightCorner = 2,
	 kBottomLeftCorner = 3,
	 kBottomRightCorner = 4
} CornerType;

@class Vector2D;
@class Matrix2D;

@interface Rectangle : Shape {
// OVERVIEW: This class implements a rectangle and the associated operations. 

@private
  double width;
  double height;
}

@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;

// rectangle corners
@property (nonatomic, readonly) NSArray* corners;

- (Vector2D*)cornerFrom:(CornerType)corner;

@end
