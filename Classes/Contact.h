//
//  Contact.h
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Shape;
@class Vector2D;

@interface Contact : NSObject {

@private
  Shape* shape1;
  Shape* shape2;
  Vector2D* point;
  Vector2D* normal;
  double separation;  
}

@property (nonatomic, retain) Shape* shape1;
@property (nonatomic, retain) Shape* shape2;
@property (nonatomic, retain) Vector2D* point;
@property (nonatomic, retain) Vector2D* normal;
@property (nonatomic, assign) double separation;

- (id)initWithShape1:(Shape*)one
              shape2:(Shape*)two
               point:(Vector2D*)p
              normal:(Vector2D*)n
          separation:(double)sep;

- (void)dealloc;

@end
