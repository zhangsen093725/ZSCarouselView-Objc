//
//  ZSRateCollectionViewCell.h
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSRateCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageNormalView;
@property (nonatomic, strong) UIImageView *imageSelectedView;

+ (NSString *)zs_identifier;

- (void)reloadImageNormal:(UIImage *)imageNormal
            imageSelected:(UIImage *)imageSelected
         selectedProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
