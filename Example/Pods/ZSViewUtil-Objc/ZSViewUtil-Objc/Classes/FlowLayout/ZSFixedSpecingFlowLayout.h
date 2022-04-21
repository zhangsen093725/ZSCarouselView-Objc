//
//  ZSFixedSpecingFlowLayout.h
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZSFixedSpecingAlignment) {
    
    ZSFixedSpecingAlignmentLeft = 0,
    ZSFixedSpecingAlignmentCenter,
    ZSFixedSpecingAlignmentRight,
};

@interface ZSFixedSpecingFlowLayout : UICollectionViewFlowLayout

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing NS_UNAVAILABLE;
- (void)setSectionInset:(UIEdgeInsets)sectionInset NS_UNAVAILABLE;

/// 设置滚动方向的方法失效，只有垂直滚动方向
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection NS_UNAVAILABLE;

/// 初始化方法
/// @param alignment 对齐方式
/// @param isLineBreakByClipping 尾行最后一个 Item 是否舍弃
- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping;

/// 初始化方法
/// @param alignment 对齐方式
/// @param isLineBreakByClipping 尾行最后一个 Item 是否舍弃
/// @param interitemSpacing 行间距
- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping
                 interitemSpacing:(CGFloat)interitemSpacing;

/// 初始化方法
/// @param alignment 对齐方式
/// @param isLineBreakByClipping 尾行最后一个 Item 是否舍弃
/// @param interitemSpacing 行间距，默认为 0
/// @param sectionInset section的外边距，默认为 UIEdgeInsetsZero
- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping
                 interitemSpacing:(CGFloat)interitemSpacing
                     sectionInset:(UIEdgeInsets)sectionInset;

/// 对齐方式
@property (nonatomic, assign, readonly) ZSFixedSpecingAlignment alignment;

/// 尾行最后一个 Item 是否舍弃
@property (nonatomic, assign, readonly) BOOL isLineBreakByClipping;

@end

NS_ASSUME_NONNULL_END
