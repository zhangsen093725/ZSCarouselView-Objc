//
//  ZSFocusFlowLayout.h
//  ZSViewUtil-Objc
//
//  Created by Josh on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSFocusFlowLayout : UICollectionViewFlowLayout

/// 聚焦位置缩放比例，默认是 1
@property (nonatomic, assign) CGFloat focusZoom;

/// 聚焦位置的透明度，默认是 1
@property (nonatomic, assign) CGFloat focusAlpha;

/// 透明度的公差
@property (nonatomic, assign) CGFloat toleranceAlpha;

@end

NS_ASSUME_NONNULL_END
