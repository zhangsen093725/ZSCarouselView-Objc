//
//  ZSScrollCarouselFullView.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSScrollCarouselFullView : ZSScrollCarouselView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection;
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection
                                   cellClass:(Class)cellClass;

@property (nonatomic, assign) CGFloat minimumSpacing;

@end

NS_ASSUME_NONNULL_END
