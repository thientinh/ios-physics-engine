//
//  Contact.m
//  Falling Bricks
//
//  Created by eLdwin on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"

#import "Shape.h"
#import "Vector2D.h"


@implementation Contact


@synthesize shape1;
@synthesize shape2;
@synthesize point;
@synthesize normal;
@synthesize separation;


- (id)initWithShape1:(Shape*)one
              shape2:(Shape*)two
               point:(Vector2D*)p
              normal:(Vector2D*)n
          separation:(double)sep {
  
  if (self = [super init]) {
    [self setShape1:one];
    [self setShape2:two];
    [self setPoint:p];
    [self setNormal:n];
    [self setSeparation:sep];
  }
  return self;
}

- (void)dealloc {
  [self setShape1:nil];
  [self setShape2:nil];
  [self setPoint:nil];
  [self setNormal:nil];
  [super dealloc];
}

@end
