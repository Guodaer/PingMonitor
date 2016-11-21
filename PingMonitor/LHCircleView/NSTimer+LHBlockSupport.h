//
//  NSTimer+LHBlockSupport.h
//  LHNormalTest
//
//  Created by bosheng on 16/7/21.
//  Copyright © 2016年 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LHBlockSupport)

+ (NSTimer *)lh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end
