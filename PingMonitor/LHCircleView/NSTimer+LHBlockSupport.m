//
//  NSTimer+LHBlockSupport.m
//  LHNormalTest
//
//  Created by bosheng on 16/7/21.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import "NSTimer+LHBlockSupport.h"

@implementation NSTimer (LHBlockSupport)

+ (NSTimer *)lh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(lh_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)lh_blockInvoke:(NSTimer *)timer
{
    void (^ block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
