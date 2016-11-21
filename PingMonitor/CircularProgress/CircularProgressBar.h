//
//  CircularProgressBar.h
//  CircularProgressBarExample
//
//  Created by cchhjj on 16/6/8.
//  Copyright © 2016年 cchhjj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CircularProgressBarType) {
    CircularProgressBarTypeRect,
    CircularProgressBarTypeCircular
    
};



@interface CircularProgressBar : UIView


@property (assign, nonatomic) CircularProgressBarType type;

//进度
@property (assign, nonatomic) CGFloat progress;

//进度条的颜色
@property (strong, nonatomic) UIColor *greyProgressColor;
@property (strong, nonatomic) UIColor *progressTintColor;

//控件的属性
@property (assign, nonatomic) CGFloat BarRedius;
@property (assign, nonatomic) CGPoint BarCenter;

//进度条的顺逆方向 默认为yes 顺时针
@property (assign, nonatomic) BOOL clockwise;

//rect时的大小设置
@property (assign, nonatomic) CGFloat rectWidth;
@property (assign, nonatomic) CGFloat rectHieght;
@property (assign, nonatomic) CGFloat designsMargin;

//circular的大小和之间的间隔
@property (assign, nonatomic) CGFloat circularRedius;
@property (assign, nonatomic) CGFloat angleDifference;

//设置开始的角度和弧形要的角度  0 ～360。
@property (assign, nonatomic) CGFloat barStartAngle;
@property (assign, nonatomic) CGFloat barLength;


- (instancetype)initWithFrame:(CGRect)frame type:(CircularProgressBarType)type;

- (void)strokeChart;


@end
