//
//  AxisView.m
//  Falling Bricks
//
//  Created by eLdwin on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AxisView.h"


@implementation AxisView


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
  CGContextRef context = UIGraphicsGetCurrentContext();  
  CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
  
  // vertical line
  CGSize half = CGSizeMake(rect.size.width * 0.5, rect.size.height * 0.5);
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width, rect.size.height);
  // arrow head
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width - 10, rect.origin.y + 10);
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width + 10, rect.origin.y + 10);
  
  // horizontal line
  CGContextMoveToPoint(context, rect.origin.x, half.height);
  CGContextAddLineToPoint(context, rect.size.width, half.height);
  CGContextMoveToPoint(context, rect.size.width, half.height);
  CGContextAddLineToPoint(context, rect.size.width - 10, half.height - 10);
  CGContextMoveToPoint(context, rect.size.width, half.height);
  CGContextAddLineToPoint(context, rect.size.width - 10, half.height + 10);
  CGContextStrokePath(context);
}


- (void)dealloc {
    [super dealloc];
}


@end
