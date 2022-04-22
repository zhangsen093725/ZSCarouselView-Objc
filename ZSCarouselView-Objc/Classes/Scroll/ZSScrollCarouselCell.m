//
//  ZSScrollCarouselCell.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselCell.h"

@implementation ZSScrollCarouselCell

+ (NSString *)zs_identifier {
    
    return NSStringFromClass([self class]);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - _minimumInteritemSpacing, CGRectGetHeight(self.bounds) - _minimumLineSpacing);
    self.imageView.frame = self.contentView.bounds;
}

// TODO: Getter
- (UIImageView *)imageView {
    
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
