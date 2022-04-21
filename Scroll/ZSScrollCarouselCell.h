//
//  ZSScrollCarouselCell.h
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSScrollCarouselCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

+ (NSString *)zs_identifier;

@end

NS_ASSUME_NONNULL_END
