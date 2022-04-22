//
//  ZSConveyorCarouseView.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSConveyorViewCell : UICollectionViewCell

+ (NSString *)zs_identifier;

@end



typedef NS_ENUM(NSUInteger, ZSConveyorCarouseViewAutoScrollDirection) {
    
    ZSConveyorCarouseViewAutoScrollDirectionLeft,
    ZSConveyorCarouseViewAutoScrollDirectionRight
};


@class ZSConveyorCarouseView;
@protocol ZSConveyorCarouseViewDataSource <NSObject>

- (NSInteger)numberOfItemsInConveyorView:(ZSConveyorCarouseView *)conveyorView;
- (UIEdgeInsets)insetInConveyorView:(ZSConveyorCarouseView *)conveyorView;
- (CGFloat)minimumInteritemSpacingInConveyorView:(ZSConveyorCarouseView *)conveyorView;
- (CGSize)conveyorView:(ZSConveyorCarouseView *)conveyorView sizeForItemAtIndex:(NSInteger)index;

@end



@protocol ZSConveyorCarouseViewDelegate <NSObject>

- (void)conveyorView:(ZSConveyorCarouseView *)conveyorView cell:(ZSConveyorViewCell *)cell forItemAtIndex:(NSInteger)index;
- (void)conveyorView:(ZSConveyorCarouseView *)conveyorView didSelectItemAtIndex:(NSInteger)index;

@end



@interface ZSConveyorCarouseView : UIView

- (instancetype)initWithContentOffset:(CGPoint)contentOffset;

@property (nonatomic, weak) id<ZSConveyorCarouseViewDelegate> delegate;
@property (nonatomic, weak) id<ZSConveyorCarouseViewDataSource> dataSource;

@property (nonatomic, assign) ZSConveyorCarouseViewAutoScrollDirection autoScrollDirection;
@property (nonatomic, assign) BOOL autoScrollEnable;
@property (nonatomic, assign) BOOL loopScrollEnable;
@property (nonatomic, assign) NSInteger fps;

- (void)reloadData;

/// 注册Cell
/// @param cellClass ZSConveyorViewCell 必须是 cellClass 的 superclass
- (void)registerClass:(nullable Class)cellClass;

@end

NS_ASSUME_NONNULL_END
