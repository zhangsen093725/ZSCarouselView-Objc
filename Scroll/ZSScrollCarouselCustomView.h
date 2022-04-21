//
//  ZSScrollCarouselCustomView.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSScrollCarouselCustomView : ZSScrollCarouselView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout;
- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout
                                   cellClass:(Class)cellClass;

@end

NS_ASSUME_NONNULL_END
