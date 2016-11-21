//
//  CircularProgressBar.m
//  CircularProgressBarExample
//
//  Created by cchhjj on 16/6/8.
//  Copyright © 2016年 cchhjj. All rights reserved.
//

//角度转弧度
#define   DegreesToRadians(degrees)  ((M_PI * (degrees)) / 180)

#import "CircularProgressBar.h"

@implementation CircularProgressBar {
    CAShapeLayer *contentLayer;
    CAShapeLayer *grayContentLayer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(CircularProgressBarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
        self.type = type;
    }
    return self;
}


- (void)defaultInit {
    contentLayer = [CAShapeLayer layer];
    grayContentLayer = [CAShapeLayer layer];
    [self.layer addSublayer:grayContentLayer];
    [self.layer addSublayer:contentLayer];
    self.barStartAngle = -90;
    self.barLength = 360;
    self.type = CircularProgressBarTypeCircular;
    self.progress = 0;
    self.greyProgressColor = [UIColor lightGrayColor];
    self.progressTintColor = [UIColor orangeColor];
    self.designsMargin = 2.0;
    self.BarRedius = self.frame.size.width/2;
    self.BarCenter = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.clockwise = YES;
    self.rectWidth = 2;
    self.rectHieght = 20;
    self.circularRedius = 7.0;
    self.angleDifference = 6.0;
    
}
//设置进度颜色
- (void)setProgressTintColor:(UIColor *)progressTintColor{
    _progressTintColor = progressTintColor;
    for (CAShapeLayer *view in contentLayer.sublayers) {
        if ([view isKindOfClass:[CAShapeLayer class]]) {
            view.fillColor = progressTintColor.CGColor;

        }
    }
}


- (void)drawRectChart {
    
    CGFloat num = self.barLength/(self.designsMargin + self.rectWidth);
    CGFloat start = 0;
    CGFloat end = 0;
    for (int i = 0; i <= num; i++) {
        start = self.barStartAngle + self.designsMargin*i+self.rectWidth*i;
        end = start + self.rectWidth;
        
        CAShapeLayer *grayLayer = [self shapeLayerWithStartAngle:start endAngle:end color:_greyProgressColor];
        [grayContentLayer addSublayer:grayLayer];
        
        CAShapeLayer *tintLayer = [self shapeLayerWithStartAngle:start endAngle:end color:_progressTintColor];
        [contentLayer addSublayer:tintLayer];
        
    }
    
    contentLayer.mask = [self layerMaskWithStartAngle:self.barStartAngle endAngle:end];
    self.progress = 0;
}

- (CAShapeLayer *)shapeLayerWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle color:(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.BarCenter radius:self.BarRedius startAngle:DegreesToRadians(startAngle) endAngle:DegreesToRadians(endAngle) clockwise:YES];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = _rectHieght;
    layer.path = path.CGPath;
    
    return layer;
}


- (CAShapeLayer *)layerMaskWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    return [self shapeLayerWithStartAngle:startAngle endAngle:endAngle color:[UIColor blackColor]];
}


- (void)drawCircularChart {
    CGFloat cangle = self.angleDifference;
    CGFloat total = 0;
    CGFloat num = 0;
    while (total < self.barLength+self.barStartAngle) {
        total = self.barStartAngle + cangle*num;
        CAShapeLayer *layer = [self circularLayerPathWithCAngle:total color:self.greyProgressColor];
        [grayContentLayer addSublayer:layer];
        CAShapeLayer *layer1 = [self circularLayerPathWithCAngle:total color:self.progressTintColor];
        [contentLayer addSublayer:layer1];
        num++;
    }

    contentLayer.mask = [self layerMaskWithStartAngle:self.barStartAngle - self.circularRedius/2 endAngle:self.barLength+self.barStartAngle + self.circularRedius/2];
    self.progress = 0;

}

- (CAShapeLayer *)circularLayerPathWithCAngle:(CGFloat)total color:(UIColor *)color {
    
    CGFloat a = self.BarCenter.x;
    CGFloat b = self.BarCenter.y;
    CGFloat x = self.BarRedius * cos(DegreesToRadians(total)) + a;
    CGFloat y = self.BarRedius * sin(DegreesToRadians(total)) + b;
    CGFloat radiiX = _circularRedius/2;
    CGFloat radiiY = _circularRedius/2;
    x = x-radiiX;
    y = y-radiiY;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, _circularRedius, _circularRedius) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radiiX, radiiY)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = color.CGColor;
    layer.lineWidth = 1;
    layer.path = path.CGPath;
    
    return layer;
    
}




//请设置好属性后调用。
- (void)strokeChart {
    [self.layer removeFromSuperlayer];
    if (self.type == CircularProgressBarTypeRect) {
        [self drawRectChart];
        
    } else if (self.type == CircularProgressBarTypeCircular) {
        [self drawCircularChart];
    }
}


- (void)setProgress:(CGFloat )progress {
    if (progress > 1) progress = 1;
    if (progress < 0) progress = 0;
    
    _progress = progress;
    
    if (_clockwise)
        ((CAShapeLayer *)contentLayer.mask).strokeEnd = progress;//顺时针
    else
        ((CAShapeLayer *)contentLayer.mask).strokeStart = 1 - progress;//逆时针
}


@end
