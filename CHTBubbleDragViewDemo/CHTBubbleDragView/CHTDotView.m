//
//  CHTDotView.m
//  CHTBobbleDragViewDemo
//
//  Created by cht on 16/11/1.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "CHTDotView.h"

@implementation CHTDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width / 2.0f;
}

@end
