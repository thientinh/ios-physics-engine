//
//  GameObject.m
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


#import "Debug.h"
#import "Shape.h"
#import "Vector2D.h"


#define KVC_WIDTH @"width"
#define KVC_HEIGHT @"height"
#define KVC_DIAMETER @"diameter"
#define KVO_ROTATION @"rotation"
#define KVO_POSITION @"position"


@implementation GameObject


- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {

  if ([keyPath isEqual:KVO_ROTATION]) {
    [self.view setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, -[(Shape*)object rotation])];
  }
  else if ([keyPath isEqual:KVO_POSITION]) {   
    Vector2D* center = [(Shape*)object center];
    [self.view setCenter:CGPointMake(center.x, 1004-center.y)];
  }
}

- (id)initWithShape:(Shape*)shape color:(UIColor*)color {
  if (self = [super init]) {
    
    if (shape.type == kCircleShape) {
      double diameter = [[shape valueForKey:KVC_DIAMETER] floatValue];
      [self.view setFrame:CGRectMake(shape.position.x, 1004-shape.position.y, diameter, diameter)];
      
      CircleView* v = [[CircleView alloc] initWithFrame:self.view.bounds];
      [self.view addSubview:v];
      [v setColor:color];
      [v release];
    }
    else if (shape.type == kRectangleShape) {
      [self.view setFrame:CGRectMake(shape.position.x, 1004-shape.position.y, [[shape valueForKey:KVC_WIDTH] floatValue], [[shape valueForKey:KVC_HEIGHT] floatValue])];
      [self.view setBackgroundColor:color];
    }
    
    [self.view setTransform:CGAffineTransformRotate(self.view.transform, -shape.rotation)];

#if TARGET_IPHONE_SIMULATOR
    AxisView* v = [[AxisView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    [v release];
#endif
    
    [shape addObserver:self forKeyPath:KVO_POSITION options:0 context:NULL];
    [shape addObserver:self forKeyPath:KVO_ROTATION options:0 context:NULL];
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  
}

- (void)dealloc {
  [super dealloc];
}

@end
