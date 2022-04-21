//
//  ZSRateCollectionViewCell.m
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/29.
//

#import "ZSRateCollectionViewCell.h"

@implementation ZSRateCollectionViewCell

+ (NSString *)zs_identifier {
    
    return NSStringFromClass(self.class);
}

- (UIImageView *)imageNormalView {
    
    if (!_imageNormalView)
    {
        _imageNormalView = [UIImageView new];
        _imageNormalView.contentMode = UIViewContentModeScaleAspectFill;
        _imageNormalView.clipsToBounds = YES;
        [self.contentView insertSubview:_imageNormalView atIndex:0];
    }
    return _imageNormalView;
}

- (UIImageView *)imageSelectedView {
    
    if (!_imageSelectedView)
    {
        _imageSelectedView = [UIImageView new];
        _imageSelectedView.contentMode = UIViewContentModeScaleAspectFill;
        _imageSelectedView.clipsToBounds = YES;
        [self.contentView addSubview:_imageSelectedView];
    }
    return _imageSelectedView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.imageNormalView.frame = self.contentView.bounds;
}

- (void)reloadImageNormal:(UIImage *)imageNormal
            imageSelected:(UIImage *)imageSelected
         selectedProgress:(CGFloat)progress {
    
    CGFloat _progress = progress > 1 ? 1 : progress;
    _progress = _progress < 0 ? 0 : _progress;
    
    UIImage *resultSelected = nil;
    
    if (_progress > 0)
    {
        CGFloat width = imageSelected.size.width * _progress * imageSelected.scale;
        CGRect newFrame = CGRectMake(0, 0, width , imageSelected.size.height * imageSelected.scale);
        
        CGImageRef resultImage = CGImageCreateWithImageInRect(imageSelected.CGImage, newFrame);
        resultSelected = [UIImage imageWithCGImage:resultImage scale:imageSelected.scale orientation:imageSelected.imageOrientation];
        CGImageRelease(resultImage);
    }
    
    CGSize imageSize = CGSizeMake(imageNormal.size.width * imageNormal.scale, imageNormal.size.height * imageNormal.scale);
    
    UIGraphicsBeginImageContext(imageSize);
   
    CGRect oneRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    [imageNormal drawInRect:oneRect];
    
    if (resultSelected)
    {
        CGRect twoRect = CGRectMake(0, 0, imageSize.width * _progress, imageSize.height);
        [resultSelected drawInRect:twoRect];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageNormalView.image = image;
}
@end
