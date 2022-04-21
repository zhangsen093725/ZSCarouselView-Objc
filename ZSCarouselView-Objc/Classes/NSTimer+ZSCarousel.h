//
//  NSTimer+ZSCarousel.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (ZSCarousel)

+ (NSTimer *)zs_carouse_supportiOS_10EarlierTimer:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(NSTimer *timer))block;


@end

NS_ASSUME_NONNULL_END
