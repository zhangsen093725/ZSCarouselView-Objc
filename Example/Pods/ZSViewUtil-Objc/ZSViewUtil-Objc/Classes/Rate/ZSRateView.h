//
//  ZSRateView.h
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZSRateView;

@protocol ZSRateViewDelegate <NSObject>

/// 选中的回调
- (void)ty_rateView:(ZSRateView *)rateView didSelectedItemForIndex:(NSInteger)index;

@end


@protocol ZSRateViewDataSource <NSObject>

/// 未选中的image
- (UIImage *)ty_rateView:(ZSRateView *)rateView itemImageNormalForIndex:(NSInteger)index;

/// 选中的image
- (UIImage *)ty_rateView:(ZSRateView *)rateView itemImageSelectedForIndex:(NSInteger)index;

/// item Size
- (CGSize)ty_rateView:(ZSRateView *)rateView itemSizeForIndex:(NSInteger)index;

@end



@interface ZSRateView : UIView

/// 进度显示开关，default YES，若为 NO，则单个选中
@property (nonatomic, assign, getter=isProgressEnable) BOOL progressEnable;

/// 选中的index, default 5
@property (nonatomic, assign) CGFloat selectedIndex;

/// 总数, default 5
@property (nonatomic, assign) NSInteger count;

/// default UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets margin;

/// default 0
@property (nonatomic, assign) CGFloat minimumSpacing;

/// delegate
@property (nonatomic, weak) id<ZSRateViewDelegate> delegate;

/// dataSource
@property (nonatomic, weak) id<ZSRateViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
