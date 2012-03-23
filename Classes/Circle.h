//
//  Circle.h
//  Falling Bricks
//
//  Created by eLdwin on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Shape.h"

@interface Circle : Shape {

@private
  double radius;
  
  // cache
  double diameter;
}


@property (nonatomic, assign) double radius;
@property (nonatomic, readonly) double diameter;


- (void)updateDiameter;


@end
