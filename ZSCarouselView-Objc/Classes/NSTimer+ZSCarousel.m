//
//  NSTimer+ZSCarousel.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "NSTimer+ZSCarousel.h"

@implementation NSTimer (ZSCarousel)

+ (NSTimer *)zs_carouse_supportiOS_10EarlierTimer:(NSTimeInterval)interval
                                          repeats:(BOOL)repeats
                                            block:(void (^)(NSTimer *timer))block{
    
    if (@available(iOS 10.0, *)) {
        return [self scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeAction:) userInfo:block repeats:repeats];
    }
}

+ (void)timeAction:(NSTimer *)timer {
    
    void (^block)(NSTimer *) = [timer userInfo];
    
    !block?:block(timer);
}

@end
