//
//  CHTBubbleDragView.m
//  CHTBobbleDragViewDemo
//
//  Created by cht on 16/11/1.
//  Copyright © 2016年 cht. All rights reserved.
//

#import "CHTBubbleDragView.h"
#import "UIView+CHTFrame.h"
#import "Define.h"



/************************CHTDotView***************************/
@interface CHTDotView : UIView

@end

@implementation CHTDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width / 2.0f;
}

@end

/************************CHTBubbleView***************************/



@interface CHTBubbleView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, copy) NSString *text;

@end

@implementation CHTBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}

- (void)initialize{
    
    self.width = [self getWidth];
    self.layer.cornerRadius = self.height/2;
    self.clipsToBounds = YES;
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.size = CGSizeMake(self.width, self.height);
    _textLabel.center = CGPointMake(self.width/2, self.height/2);
    _textLabel.font = [UIFont systemFontOfSize:12.0f];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = _text;
    [self addSubview:_textLabel];
}

- (void)setText:(NSString *)text{
    
    self.width = [self getWidth];
    self.layer.cornerRadius = self.height/2;
    _textLabel.size = CGSizeMake(self.width, self.height);
    _textLabel.center = CGPointMake(self.width/2, self.height/2);
    _textLabel.text = _text;
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
        return textWidth + self.height;
    }
    return self.width;
}
@end

/************************CHTBubbleDragView***************************/
@interface CHTBubbleDragView ()

@property (nonatomic, strong) CHTBubbleView *headDotView;
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

#pragma mark - set methods
- (void)setThemeColor:(UIColor *)themeColor{
    
    _themeColor = themeColor;
    _shapeLayer.fillColor = _themeColor.CGColor;
    _headDotView.backgroundColor = _themeColor;
    _tailDotView.backgroundColor = _themeColor;
}

- (void)setTextColor:(UIColor *)textColor{
    
    _textColor = textColor;
    _headDotView.textLabel.textColor = _textColor;
}

- (void)setText:(NSString *)text{

    _text = text;
    _headDotView.textLabel.text = _text;
}

#pragma mark - UI
- (void)setupUI{
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.width, self.height);
    _shapeLayer.anchorPoint = CGPointMake(0, 0);
    _shapeLayer.position = CGPointMake(0, 0);
    [self.layer addSublayer:_shapeLayer];
    
    _tailDotView = [[CHTDotView alloc]initWithFrame:CGRectMake(0, 0, TAIL_DOT_RADIUS, TAIL_DOT_RADIUS)];
    _tailDotView.center = CGPointMake(self.centerX, self.centerY);
    [self addSubview:_tailDotView];
    
    _headDotView = [[CHTBubbleView alloc]initWithFrame:CGRectMake(0, 0, HEAD_DOT_RADIUS, HEAD_DOT_RADIUS)];
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
    
    self.themeColor = COLOR_DEFAULT;
}

#pragma mark - methods
- (CGFloat)distabceBetweenDots{
    
    CGFloat headX = _headDotView.centerX;
    CGFloat headY = _headDotView.centerY;
    CGFloat tailX = _tailDotView.centerX;
    CGFloat tailY = _tailDotView.centerY;
    
    CGFloat distance = sqrt((headX - tailX)*(headX - tailX) + (headY - tailY)*(headY - tailY));
    
    return distance;
}

- (void)reloadBezierpath{
    
    CGFloat headX = _headDotView.centerX;
    CGFloat headY = _headDotView.centerY;
    CGFloat headR = _headDotView.height / 2;
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
        
        _headDotView.center = CGPointMake(self.width/2, self.height/2);
    } completion:NULL];
}

- (void)boom{

    _headDotView.backgroundColor = [UIColor whiteColor];
    [_boomImageView startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
}

- (void)broke{
    
    _shapeLayer.path = nil;
    _tailDotView.hidden = YES;
    _isBroken = YES;
}

#pragma mark - pan gesture
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
