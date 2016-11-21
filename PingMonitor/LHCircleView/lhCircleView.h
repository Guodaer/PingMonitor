//
//  lhCircleView.h
//  LHNormalTest
//
//  Created by bosheng on 16/7/27.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lhCircleView : UIView
{
//    UIColor *progressColor;//进度条颜色

}
@property (nonatomic,strong)UILabel * contentLabel;//内容

@property (nonatomic,assign)CGFloat progressValue;//

@property (nonatomic, strong) UIColor *progressColor;//进度条颜色


- (instancetype)initWithFrame:(CGRect)frame;

@end
