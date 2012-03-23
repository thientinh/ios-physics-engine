//
//  ArrowHeadView.m
//  Falling Bricks
//
//  Created by eLdwin on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArrowHeadView.h"


@implementation ArrowHeadView


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
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

  // vertical line
  CGSize half = CGSizeMake(rect.size.width * 0.5, rect.size.height * 0.5);
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width, rect.size.height);
  // arrow head
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width - 10, rect.origin.y + 10);
  CGContextMoveToPoint(context, half.width, rect.origin.y);
  CGContextAddLineToPoint(context, half.width + 10, rect.origin.y + 10);
}


- (void)dealloc {
    [super dealloc];
}


@end
