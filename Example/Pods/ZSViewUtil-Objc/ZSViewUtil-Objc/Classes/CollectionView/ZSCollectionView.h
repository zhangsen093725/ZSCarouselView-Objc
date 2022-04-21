//
//  ZSCollectionView.h
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSCollectionView : UICollectionView<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL shouldMultipleGestureRecognize;

@property (nonatomic, strong) UIView *collectionViewTopView;

@property (nonatomic, strong) UIView *collectionViewBottomView;

@property (nonatomic, strong) UIView *collectionViewLeftView;

@property (nonatomic, strong) UIView *collectionViewRightView;

@end

NS_ASSUME_NONNULL_END
