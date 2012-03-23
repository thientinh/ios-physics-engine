//
//  Falling_BricksViewController.h
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class World;

@interface Falling_BricksViewController : UIViewController <UIAccelerometerDelegate> {
  World* world;
  NSMutableArray* gameObjects;
}

@end

