//
//  ZSWaterFlowLayout.h
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZSWaterFlowLayout;

@protocol ZSWaterFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

/// collectionItem size
- (CGSize)zs_collectionView:(UICollectionView *)collectionView
                 flowLayout:(ZSWaterFlowLayout *)flowLayout
                minimumSize:(CGSize)minimumSize
     sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath NS_UNAVAILABLE;

@optional

/// 是否允许超过大小
- (BOOL)zs_collectionView:(UICollectionView *)collectionView
               flowLayout:(ZSWaterFlowLayout *)flowLayout
shouldBeyondSizeOfSection:(NSInteger)section;

/// 设置每列的 inset（在sectionInset基础上，加上每列的 inset）
- (UIEdgeInsets)zs_collectionView:(UICollectionView *)collectionView
                       flowLayout:(ZSWaterFlowLayout *)flowLayout
            insetForColumnAtIndex:(NSInteger)column
                      columnCount:(NSInteger)columnCount;

/// 每个section 列数（默认2列）
- (NSInteger)zs_collectionView:(UICollectionView *)collectionView
                    flowLayout:(ZSWaterFlowLayout *)flowLayout columnNumberOfSection:(NSInteger)section;


/// section 的 header 与 上一组 section 的 footer 的间距（默认为0）
- (CGFloat)zs_collectionView:(UICollectionView *)collectionView
                  flowLayout:(ZSWaterFlowLayout *)flowLayout sectionSpacingForSection:(NSInteger)section;

@end

@interface ZSWaterFlowLayout : UICollectionViewFlowLayout




@end

NS_ASSUME_NONNULL_END
