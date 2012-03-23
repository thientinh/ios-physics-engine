//
//  CircleView.m
//  Falling Bricks
//
//  Created by eLdwin on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CircleView.h"


@implementation CircleView


@synthesize color;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
      [self setOpaque:NO];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, self.color.CGColor);
  CGContextFillEllipseInRect(context, rect);  
}


- (void)dealloc {
  [color release];
  [super dealloc];
}


@end
