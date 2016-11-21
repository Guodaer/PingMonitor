//
//  GDFadeView.h
//  FadeView
//
//  Created by xiaoyu on 15/11/13.
//  Copyright © 2015年 guoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDFadeView : UIView
@property (nonatomic,strong) NSString *text;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *foreColor;
@property (nonatomic,strong) UIFont *font;

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration;

@end
