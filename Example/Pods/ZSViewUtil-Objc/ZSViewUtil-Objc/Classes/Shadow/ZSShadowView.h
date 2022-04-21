//
//  ZSShadowView.h
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSShadowView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;


@property (nonatomic, strong) UIColor *shadowFillColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGPoint shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;
@property (nonatomic, assign) CGFloat shadowRadius;

@end

NS_ASSUME_NONNULL_END
