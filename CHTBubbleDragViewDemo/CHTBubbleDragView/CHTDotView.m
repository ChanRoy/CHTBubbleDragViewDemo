//
//  CHTDotView.m
//  CHTBobbleDragViewDemo
//
//  Created by cht on 16/11/1.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "CHTDotView.h"
#import "UIView+CHTFrame.h"

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

/**********************************************************/

#define MAX_TEXT_LENGTH 10

@interface CHTBubbleView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation CHTBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _text = @"99999999";
        self.width = [self getWidth];
        self.layer.cornerRadius = self.height/2;
        self.clipsToBounds = YES;
 
        self.backgroundColor = [UIColor grayColor];
        _textLabel = [[UILabel alloc]init];
        _textLabel.size = CGSizeMake(self.width, frame.size.height);
        _textLabel.center = CGPointMake(self.width/2, self.height/2);
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = _text;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
    }
    return self;
}

- (CGFloat)getWidth{
    
    CGFloat textWidth = 0;
    if (_text) {
        
        CGSize maxSize = [_text boundingRectWithSize:CGSizeMake(999, self.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f]} context:nil].size;
        if (maxSize.width > MAX_TEXT_LENGTH) {
            textWidth = MAX_TEXT_LENGTH;
        }else if (maxSize.width < self.height/2){
            textWidth = self.height/2;
        }else{
            textWidth = maxSize.width;
        }
        NSLog(@"%.2f",textWidth);
        return textWidth + self.height;
    }
    return self.width;
}

@end
