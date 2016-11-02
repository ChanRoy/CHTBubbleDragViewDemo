//
//  UIView+CHTFrame.m
//  CHTLoadingViewOC
//
//  Created by cht on 16/10/27.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "UIView+CHTFrame.h"

@implementation UIView (CHTFrame)

//x
- (void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    
    return self.frame.origin.x;
}

//y
- (void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    
    return self.frame.origin.y;
}

//width
- (void)setWidth:(CGFloat)width{
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width{
    
    return self.frame.size.width;
}

//height
- (void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height{
    
    return self.frame.size.height;
}

//centerX
- (void)setCenterX:(CGFloat)centerX{
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX{
    
    return self.center.x;
}

//centerY
- (void)setCenterY:(CGFloat)centerY{
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY{
    
    return self.center.y;
}

//bottom
- (void)setBottom:(CGFloat)bottom{
    
    CGRect frame = self.frame;
    frame.size.height = bottom - frame.origin.y;
    self.frame = frame;
}
- (CGFloat)bottom{
    
    return self.frame.origin.x + self.frame.size.height;
}

//size
- (void)setSize:(CGSize)size{
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size{
    
    return self.frame.size;
}

//origin
- (void)setOrigin:(CGPoint)origin{
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    
    return self.frame.origin;
}

@end
