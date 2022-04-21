//
//  ZSButton.h
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZSButtonImagePosition) {
    ZSButtonImageLeft = 0,
    ZSButtonImageRight,
    ZSButtonImageTop,
    ZSButtonImageBottom
};

@interface ZSButton : UIButton

@property (nonatomic, assign) ZSButtonImagePosition imagePosition;

@end

NS_ASSUME_NONNULL_END
