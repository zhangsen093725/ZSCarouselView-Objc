//
//  ZSPlainFlowLayout.h
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSPlainFlowLayout : UICollectionViewFlowLayout

// 设置停留偏移量Y，默认为64
@property (nonatomic, assign) CGFloat plainOffset;

// 需要头部悬浮的section, iOS 9.0 以上 sectionHeadersPinToVisibleBounds = NO 时生效，默认为 NSNotFound 表示全部悬浮
@property (nonatomic, assign) NSInteger plainSection;

@end

NS_ASSUME_NONNULL_END
