//
//  PERectangle.m
//  
//  CS3217 || Assignment 1
//  Name: Eldwin Liew
//

#import "Rectangle.h"

#import "Vector2D.h"
#import "Matrix2D.h"


@implementation Rectangle
// OVERVIEW: This class implements a rectangle and the associated
//             operations.


@synthesize width;
@synthesize height;

- (id)init {
  if (self = [super init]) {
    [self setWidth:0.0];
    [self setHeight:0.0];
  }
  return self;
}


- (ShapeType)type {
  return kRectangleShape;
}


- (Vector2D*)center {
  // EFFECTS: returns the coordinates of the centre of mass for this rectangle.
  return [Vector2D vectorWith:(self.position.x + (self.width * 0.5)) y:(self.position.y + (self.height * 0.5))];
}


- (void)updateInertia {
  inertia = self.mass * (pow(self.width, 2) + pow(self.height, 2)) / 12.0;
  invInertia = 1.0 / inertia;
}


- (void)updateHalfVector {
  halfVector = [[Vector2D vectorWith:(self.width * 0.5) y:(self.height * 0.5)] retain];
}


- (void)setWidth:(double)w {
  width = w;
  [self updateInertia];
  [self updateHalfVector];
}


- (void)setHeight:(double)h {
  height = h;
  [self updateInertia];
  [self updateHalfVector];
}


- (Vector2D*)cornerFrom:(CornerType)corner {
  // REQUIRES: corner is a enum constant defined in Shape.h as follows:
  //           kTopLeftCorner, kTopRightCorner, kBottomLeftCorner, kBottomRightCorner 
  // EFFECTS: returns the coordinates of the specified rotated rectangle corner 

  Vector2D* point = self.position;
  
  switch ( corner )
  {
    case kTopLeftCorner:
      point = [point add:[Vector2D vectorWith:0 y:self.height]];
      break;
      
    case kTopRightCorner:
      point = [point add:[Vector2D vectorWith:self.width y:self.height]];
      break;

    case kBottomLeftCorner:
      break;
      
    case kBottomRightCorner:
      point = [point add:[Vector2D vectorWith:self.width y:0]];
      break;
  }

  Vector2D* c = self.center;
  CGAffineTransform matrix = CGAffineTransformMakeTranslation(c.x, c.y);
  matrix = CGAffineTransformRotate(matrix, self.rotation);
  matrix = CGAffineTransformTranslate(matrix, -c.x, -c.y);
  CGPoint p = CGPointApplyAffineTransform(CGPointMake(point.x, point.y), matrix);
  
  return [Vector2D vectorWith:p.x y:p.y];
}


- (NSArray*) corners
{
  Vector2D* topLeft = [self cornerFrom: kTopLeftCorner];
  Vector2D* topRight = [self cornerFrom: kTopRightCorner];
  Vector2D* bottomRight = [self cornerFrom: kBottomRightCorner];
  Vector2D* bottomLeft = [self cornerFrom: kBottomLeftCorner];
  return [[[NSArray alloc] initWithObjects: topLeft, topRight, bottomRight, bottomLeft, nil] autorelease];
}


- (CGRect)axisAlignedBoundingBox {	
  // EFFECTS: returns the bounding box of this shape.

  // translate centre of mass of object to origin, rotate and translate back
  Vector2D* c = self.center;
  CGAffineTransform matrix = CGAffineTransformMakeTranslation(c.x, c.y);
  matrix = CGAffineTransformRotate(matrix, self.rotation);
  matrix = CGAffineTransformTranslate(matrix, -c.x, -c.y);
  return CGRectApplyAffineTransform(CGRectMake( self.position.x, self.position.y, self.width, self.height ), matrix);
}

@end

