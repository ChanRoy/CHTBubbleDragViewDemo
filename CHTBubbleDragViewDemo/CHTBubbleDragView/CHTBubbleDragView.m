//
//  CHTBubbleDragView.m
//  CHTBobbleDragViewDemo
//
//  Created by cht on 16/11/1.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "CHTBubbleDragView.h"
#import "CHTDotView.h"
#import "UIView+CHTFrame.h"

#define HEAD_DOT_RADIUS 30.0
#define TAIL_DOT_RADIUS 20.0
#define TAILDOT_SCALE_MIN 0.4

@interface CHTBubbleDragView ()

@property (nonatomic, strong) CHTDotView *headDotView;
@property (nonatomic, strong) CHTDotView *tailDotView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIImageView *boomImageView;

@end

@implementation CHTBubbleDragView{
    
    BOOL _isBroken;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.brokeDistance = 150;
        
        [self setupUI];
        
    }
    return self;
}

- (CGFloat)distabceBetweenDots{
    
    CGFloat headX = _headDotView.centerX;
    CGFloat headY = _headDotView.centerY;
    CGFloat tailX = _tailDotView.centerX;
    CGFloat tailY = _tailDotView.centerY;
    
    CGFloat distance = sqrt((headX - tailX)*(headX - tailX) + (headY - tailY)*(headY - tailY));
    
    return distance;
}

- (void)setupUI{
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.width, self.height);
    _shapeLayer.fillColor = [UIColor grayColor].CGColor;
    _shapeLayer.anchorPoint = CGPointMake(0, 0);
    _shapeLayer.position = CGPointMake(0, 0);
    [self.layer addSublayer:_shapeLayer];
    
    _tailDotView = [[CHTDotView alloc]initWithFrame:CGRectMake(0, 0, TAIL_DOT_RADIUS, TAIL_DOT_RADIUS)];
    _tailDotView.center = CGPointMake(self.centerX, self.centerY);
    [self addSubview:_tailDotView];
    
    _headDotView = [[CHTDotView alloc]initWithFrame:CGRectMake(0, 0, HEAD_DOT_RADIUS, HEAD_DOT_RADIUS)];
    _headDotView.center = CGPointMake(self.centerX, self.centerY);
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragDot:)];
    [_headDotView addGestureRecognizer:pan];
    [self addSubview:_headDotView];
    
    _boomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HEAD_DOT_RADIUS, HEAD_DOT_RADIUS)];
    _boomImageView.animationImages = @[[UIImage imageNamed:@"CHTBubbleDragViewDemo.bundle/boom0"],
                                       [UIImage imageNamed:@"CHTBubbleDragViewDemo.bundle/boom1"],
                                       [UIImage imageNamed:@"CHTBubbleDragViewDemo.bundle/boom2"],
                                       [UIImage imageNamed:@"CHTBubbleDragViewDemo.bundle/boom3"],
                                       [UIImage imageNamed:@"CHTBubbleDragViewDemo.bundle/boom4"]];
    
    _boomImageView.animationRepeatCount = 1;
    _boomImageView.animationDuration = 0.5;
    [_headDotView addSubview:_boomImageView];
}

- (void)reloadBezierpath{
    
    CGFloat headX = _headDotView.centerX;
    CGFloat headY = _headDotView.centerY;
    CGFloat headR = _headDotView.width / 2;
    CGFloat tailX = _tailDotView.centerX;
    CGFloat tailY = _tailDotView.centerY;
    CGFloat tailR = _tailDotView.width / 2;
    
    CGFloat distance = [self distabceBetweenDots];
    
    CGFloat sinDegree = (headX - tailX) / distance;
    CGFloat cosDegree = (headY - tailY) / distance;
    
    CGPoint pointA = CGPointMake(tailX - tailR * cosDegree, tailY + tailR * sinDegree);
    CGPoint pointB = CGPointMake(tailX + tailR * cosDegree, tailY - tailR * sinDegree);
    CGPoint pointC = CGPointMake(headX + headR * cosDegree, headY - headR * sinDegree);
    CGPoint pointD = CGPointMake(headX - headR * cosDegree, headY + headR * sinDegree);
    CGPoint pointM = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    CGPoint pointN = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointN];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointM];
    
    _shapeLayer.path = path.CGPath;
}

- (void)placeHeadDot{
    
    _tailDotView.hidden = YES;
    _shapeLayer.path = nil;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _headDotView.center = CGPointMake(self.centerX, self.centerY);
    } completion:NULL];
}

- (void)boom{

    _headDotView.backgroundColor = [UIColor whiteColor];
    [_boomImageView startAnimating];
}

- (void)broke{
    
    _shapeLayer.path = nil;
    _tailDotView.hidden = YES;
    _isBroken = YES;
}

- (void)dragDot:(UIPanGestureRecognizer *)pan{
    
    CGPoint location = [pan locationInView:_headDotView.superview];
    self.headDotView.center = location;
    
    CGFloat distance = [self distabceBetweenDots];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            
            _tailDotView.hidden = NO;
            _isBroken = NO;
        }
            break;
        
        case UIGestureRecognizerStateChanged:{
            
            if (distance <= _brokeDistance && !_isBroken) {
                
                CGFloat scale = (1 - distance / self.brokeDistance);
                scale = MAX(TAILDOT_SCALE_MIN, scale);
                _tailDotView.transform = CGAffineTransformMakeScale(scale, scale);
                [self reloadBezierpath];

            }
            else{
                
                [self broke];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            if (distance <= _brokeDistance) {
                
                [self placeHeadDot];
            }else{
                
                [self boom];
            }
        }
        default:
            break;
    }
}

@end
