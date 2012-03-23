//
//  Falling_BricksAppDelegate.h
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Falling_BricksViewController;

@interface Falling_BricksAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Falling_BricksViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Falling_BricksViewController *viewController;

@end

