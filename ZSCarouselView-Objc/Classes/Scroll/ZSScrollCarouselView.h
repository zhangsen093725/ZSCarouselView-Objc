//
//  ZSScrollCarouselView.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import <UIKit/UIKit.h>
#import "ZSScrollCarouselCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ZSScrollCarouselView;
@protocol ZSScrollCarouselViewDataSource <NSObject>

/// 滚动视图的总数
/// @param carouseView carouseView
- (NSInteger)zs_numberOfItemcarouseView:(ZSScrollCarouselView *)carouseView;

/// 自定义Cell
/// @param carouseView carouseView
/// @param index 当前的index
- (NSString *)zs_carouseView:(ZSScrollCarouselView *)carouseView dequeueReusableCellWithReuseIdentifierAtIndex:(NSInteger)index;

@end

@protocol ZSScrollCarouselViewDelegate <NSObject>

/// 滚动视图Item的点击
/// @param carouseView carouseView
/// @param index 当前的index
- (void)zs_carouseView:(ZSScrollCarouselView *)carouseView didSelectedItemForIndex:(NSInteger)index;

/// 滚动视图的回调
/// @param carouseView carouseView
/// @param index 当前的index
- (void)zs_carouseViewDidScroll:(ZSScrollCarouselView *)carouseView index:(NSInteger)index;

/// 配置滚动到的视图属性
/// @param cell 当前的carouseCell
/// @param index 当前的index
- (void)zs_configCarouseCell:(UICollectionViewCell *)cell itemAtIndex:(NSInteger)index;

@end

@interface ZSScrollCarouselView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 滚动视图的数据配置
@property (nonatomic, weak) id<ZSScrollCarouselViewDataSource> dataSource;

/// 滚动视图的交互
@property (nonatomic, weak) id<ZSScrollCarouselViewDelegate> delegate;

/// 是否开启自动滚动，默认为 YES
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;

/// 自动滚动的间隔时长，默认是 3 秒
@property (nonatomic, assign) NSTimeInterval interval;

/// 是否开启循环滚动，默认是true
@property (nonatomic, assign, getter=isLoopScroll) BOOL loopScroll;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) NSInteger cachePage;
@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign, readonly) NSInteger itemCount;
@property (nonatomic, assign, readonly) NSInteger loopScrollItemCount;

- (void)configCollectionView:(UICollectionView *)collectionView;
- (void)reloadData;
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
- (NSInteger)scrollCarouseIndexFromPage:(NSInteger)page;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
