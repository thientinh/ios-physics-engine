//
//  GameObject.h
//  Falling Bricks
//
//  Created by eLdwin on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shape;

@interface GameObject : UIViewController {

}

- (id)initWithShape:(Shape*)shape color:(UIColor*)color;

@end
