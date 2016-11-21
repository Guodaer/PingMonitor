//
//  lhCircleView.m
//  LHNormalTest
//
//  Created by bosheng on 16/7/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "lhCircleView.h"
#import "NSTimer+LHBlockSupport.h"

static const CGFloat progressStrokeWidth = 10;

@interface lhCircleView ()
{
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;//用来填充的图层
    UIBezierPath *backGroundBezierPath;//背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;//用来填充的贝赛尔曲线
    
    UIColor *progressTrackColor;//进度条轨道颜色
    
    NSTimer * timer;//定时器用作动画
    CGPoint center;//中心点
}

@end

@implementation lhCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.progressColor = [UIColor clearColor];
        progressTrackColor = [UIColor lightGrayColor];
        
        //创建背景图层
        backGroundLayer = [CAShapeLayer layer];
        backGroundLayer.fillColor = XUIColor(0x000000, 0.1).CGColor;
        backGroundLayer.frame = self.bounds;
        
        //创建填充图层
        frontFillLayer = [CAShapeLayer layer];
        frontFillLayer.fillColor = nil;
        frontFillLayer.frame = self.bounds;
        
        frontFillLayer.strokeColor = self.progressColor.CGColor;
        backGroundLayer.strokeColor = progressTrackColor.CGColor;
        
        center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds)-progressStrokeWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        backGroundLayer.path = backGroundBezierPath.CGPath;
        
        frontFillLayer.lineWidth = progressStrokeWidth;
        backGroundLayer.lineWidth = progressStrokeWidth;
        
        [self.layer addSublayer:backGroundLayer];
        [self.layer addSublayer:frontFillLayer];
    }
    
    return self;
}

- (void)setProgressColor:(UIColor *)progressColor{
    
    frontFillLayer.strokeColor = progressColor.CGColor;

}
- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }

    __weak typeof(self) wSelf = self;
    __block CGFloat progress = 0.0;
    timer = [NSTimer lh_scheduledTimerWithTimeInterval:0.01 block:^{
        
        if (progress >= _progressValue || progress >= 1.0f) {
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            return;
        }
        else{
            frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(wSelf.bounds)-progressStrokeWidth)/2.f startAngle:-M_PI_2 endAngle:(2*M_PI)*progress-M_PI_2 clockwise:YES];
            frontFillLayer.path = frontFillBezierPath.CGPath;
        }
        progress += 0.01*(_progressValue);
        
    } repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
