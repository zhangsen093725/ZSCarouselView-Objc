//
//  ZSButton.m
//  YunnanTravel
//
//  Created by Josh on 2020/12/3.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "ZSButton.h"

@implementation ZSButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    switch (_imagePosition)
    {
        case ZSButtonImageLeft:
        {
            [self layoutImageLeft];
            break;
        }
        case ZSButtonImageRight:
        {
            [self layoutImageRight];
            break;
        }
        case ZSButtonImageTop:
        {
            [self layoutImageTop];
            break;
        }
        case ZSButtonImageBottom:
        {
            [self layoutImageBottom];
            break;
        }
    }
}

- (CGSize)intrinsicContentSize {
    
    CGSize imageViewSize = [self.imageView intrinsicContentSize];
    
    if (CGSizeEqualToSize(imageViewSize, CGSizeMake(-1, -1)))
    {
        imageViewSize = CGSizeZero;
    }
    
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    if (CGSizeEqualToSize(titleLabelSize, CGSizeMake(-1, -1)))
    {
        titleLabelSize = CGSizeZero;
    }
     
    CGFloat imageViewWidth = imageViewSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right;
    CGFloat imageViewHeight = imageViewSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom;
    
    CGFloat titleLabeWidth = titleLabelSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right;
    CGFloat titleLabeHeight = titleLabelSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom;
    
    if (_imagePosition == ZSButtonImageLeft || _imagePosition == ZSButtonImageRight)
    {
        
        return CGSizeMake(imageViewWidth + titleLabeWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                          MAX(imageViewHeight, titleLabeHeight) + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    }
    
    return CGSizeMake(MAX(imageViewWidth, titleLabeWidth) + self.contentEdgeInsets.left + self.contentEdgeInsets.right,
                      imageViewHeight + titleLabeHeight + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
}

- (CGSize)imageViewSize {
    
    CGSize imageViewSize = [self.imageView intrinsicContentSize];
    CGFloat imageViewHeight = MIN(imageViewSize.height, CGRectGetHeight(self.frame) - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom));
    imageViewHeight = imageViewHeight > 0 ? imageViewHeight : 0;
    
    CGFloat imageScale = imageViewSize.height > 0 ? imageViewSize.width / imageViewSize.height : 1;
    CGFloat imageViewWidth = MIN(imageViewHeight * imageScale, CGRectGetWidth(self.frame) - (self.contentEdgeInsets.left + self.contentEdgeInsets.right));
    imageViewWidth = imageViewWidth > 0 ? imageViewWidth : 0;
    
    return CGSizeMake(imageViewWidth, imageViewHeight);
}

- (void)layoutImageLeft {
    
    CGSize imageViewSize = [self imageViewSize];
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    CGFloat contentWidth = CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.right + self.imageEdgeInsets.left + self.titleEdgeInsets.right + self.titleEdgeInsets.left);
    CGFloat contentHeight = CGRectGetHeight(self.frame);
    
    titleLabelSize = CGSizeMake(MIN(titleLabelSize.width, contentWidth), MIN(contentHeight, titleLabelSize.height));
    
    CGFloat imageViewX = 0;
    
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentCenter:
        {
            imageViewX = (CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.right +
                                                       titleLabelSize.width + self.titleEdgeInsets.left)) * 0.5;
            
            break;
        }
        case UIControlContentHorizontalAlignmentLeft:
        {
            imageViewX = self.imageEdgeInsets.left;
            
            break;
        }
        case UIControlContentHorizontalAlignmentRight:
        {
            imageViewX = (CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.right +
                                                        titleLabelSize.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right));
            
            break;
        }
        case UIControlContentHorizontalAlignmentFill:
        {
            imageViewX = self.imageEdgeInsets.left;
            
            break;
        }
        default:
            break;
    }
    
    CGFloat titleLabelY = 0;
    CGFloat imageViewY = 0;
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentCenter:
        {
            imageViewY = (CGRectGetHeight(self.frame) - imageViewSize.height) * 0.5 + self.imageEdgeInsets.top - self.imageEdgeInsets.bottom;
            titleLabelY = (CGRectGetHeight(self.frame) - titleLabelSize.height) * 0.5 + self.titleEdgeInsets.top - self.titleEdgeInsets.bottom;
            
            break;
        }
        case UIControlContentVerticalAlignmentTop:
        {
            imageViewY = self.imageEdgeInsets.top;
            titleLabelY = self.titleEdgeInsets.top;
            
            break;
        }
        case UIControlContentVerticalAlignmentBottom:
        {
            imageViewY = (CGRectGetHeight(self.frame) - imageViewSize.height - self.imageEdgeInsets.bottom);
            titleLabelY = (CGRectGetHeight(self.frame) - titleLabelSize.height - self.titleEdgeInsets.bottom);
            
            break;
        }
        case UIControlContentVerticalAlignmentFill:
        {
            imageViewY = self.imageEdgeInsets.top;
            titleLabelY = self.titleEdgeInsets.top;
            
            break;
        }
        default:
            break;
    }
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewSize.width, imageViewSize.height);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + self.titleEdgeInsets.left,
                                       titleLabelY,
                                       titleLabelSize.width,
                                       titleLabelSize.height);
}

- (void)layoutImageRight {
    
    CGSize imageViewSize = [self imageViewSize];
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    CGFloat contentWidth = CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.right + self.imageEdgeInsets.left + self.titleEdgeInsets.right + self.titleEdgeInsets.left);
    CGFloat contentHeight = CGRectGetHeight(self.frame);
    
    titleLabelSize = CGSizeMake(MIN(titleLabelSize.width, contentWidth), MIN(contentHeight, titleLabelSize.height));
    
    CGFloat titleLabelX = 0;
    
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentCenter:
        {
            titleLabelX = (CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.left +
                                                       titleLabelSize.width + self.titleEdgeInsets.right)) * 0.5;
            
            break;
        }
        case UIControlContentHorizontalAlignmentLeft:
        {
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        case UIControlContentHorizontalAlignmentRight:
        {
            titleLabelX = (CGRectGetWidth(self.frame) - (imageViewSize.width + self.imageEdgeInsets.left + self.imageEdgeInsets.right +
                                                        titleLabelSize.width  + self.titleEdgeInsets.right));
            
            break;
        }
        case UIControlContentHorizontalAlignmentFill:
        {
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        default:
            break;
    }
    
    CGFloat titleLabelY = 0;
    CGFloat imageViewY = 0;
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentCenter:
        {
            imageViewY = (CGRectGetHeight(self.frame) - imageViewSize.height) * 0.5 + self.imageEdgeInsets.top - self.imageEdgeInsets.bottom;
            titleLabelY = (CGRectGetHeight(self.frame) - titleLabelSize.height) * 0.5 + self.titleEdgeInsets.top - self.titleEdgeInsets.bottom;
            
            break;
        }
        case UIControlContentVerticalAlignmentTop:
        {
            imageViewY = self.imageEdgeInsets.top;
            titleLabelY = self.titleEdgeInsets.top;
            
            break;
        }
        case UIControlContentVerticalAlignmentBottom:
        {
            imageViewY = (CGRectGetHeight(self.frame) - imageViewSize.height - self.imageEdgeInsets.bottom);
            titleLabelY = (CGRectGetHeight(self.frame) - titleLabelSize.height - self.titleEdgeInsets.bottom);
            
            break;
        }
        case UIControlContentVerticalAlignmentFill:
        {
            imageViewY = self.imageEdgeInsets.top;
            titleLabelY = self.titleEdgeInsets.top;
            
            break;
        }
        default:
            break;
    }
    
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
    
    CGFloat imageViewX = CGRectGetMaxX(self.titleLabel.frame) + self.imageEdgeInsets.left;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewSize.width, imageViewSize.height);
}

- (void)layoutImageTop {
    
    CGSize imageViewSize = [self imageViewSize];
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    CGFloat contentHeight = CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
    titleLabelSize = CGSizeMake(MIN(titleLabelSize.width, contentWidth), MIN(contentHeight, titleLabelSize.height));
    
    CGFloat titleLabelX = 0;
    CGFloat imageViewX = 0;
    
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentCenter:
        {
            imageViewX = (CGRectGetWidth(self.frame) - imageViewSize.width) * 0.5 + self.imageEdgeInsets.left - self.imageEdgeInsets.right;
            titleLabelX = (CGRectGetWidth(self.frame) - titleLabelSize.width) * 0.5 + self.titleEdgeInsets.left - self.titleEdgeInsets.right;
            
            break;
        }
        case UIControlContentHorizontalAlignmentLeft:
        {
            imageViewX = self.imageEdgeInsets.left;
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        case UIControlContentHorizontalAlignmentRight:
        {
            imageViewX = CGRectGetWidth(self.frame) - imageViewSize.width - self.imageEdgeInsets.right;
            titleLabelX = CGRectGetWidth(self.frame) - titleLabelSize.width - self.titleEdgeInsets.right;
            
            break;
        }
        case UIControlContentHorizontalAlignmentFill:
        {
            imageViewX = self.imageEdgeInsets.left;
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        default:
            break;
    }
    
    CGFloat imageViewY = 0;
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentCenter:
        {
            imageViewY = (CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.bottom +
                                                         titleLabelSize.height + self.titleEdgeInsets.top)) * 0.5;
            
            break;
        }
        case UIControlContentVerticalAlignmentTop:
        {
            imageViewY = self.imageEdgeInsets.top;
            
            break;
        }
        case UIControlContentVerticalAlignmentBottom:
        {
            imageViewY = (CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.bottom +
                                                         titleLabelSize.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom));
            
            break;
        }
        case UIControlContentVerticalAlignmentFill:
        {
            imageViewY = self.imageEdgeInsets.top;
            
            break;
        }
        default:
            break;
    }
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewSize.width, imageViewSize.height);
    self.titleLabel.frame = CGRectMake(titleLabelX, CGRectGetMaxY(self.imageView.frame) + self.titleEdgeInsets.top,
                                       titleLabelSize.width,
                                       titleLabelSize.height);
}

- (void)layoutImageBottom {
    
    CGSize imageViewSize = [self imageViewSize];
    CGSize titleLabelSize = [self.titleLabel intrinsicContentSize];
    
    CGFloat contentWidth = CGRectGetWidth(self.frame);
    CGFloat contentHeight = CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
    titleLabelSize = CGSizeMake(MIN(titleLabelSize.width, contentWidth), MIN(contentHeight, titleLabelSize.height));
    
    CGFloat titleLabelX = 0;
    CGFloat imageViewX = 0;
    
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentCenter:
        {
            imageViewX = (CGRectGetWidth(self.frame) - imageViewSize.width) * 0.5 + self.imageEdgeInsets.left - self.imageEdgeInsets.right;
            titleLabelX = (CGRectGetWidth(self.frame) - titleLabelSize.width) * 0.5 + self.titleEdgeInsets.left - self.titleEdgeInsets.right;
            
            break;
        }
        case UIControlContentHorizontalAlignmentLeft:
        {
            imageViewX = self.imageEdgeInsets.left;
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        case UIControlContentHorizontalAlignmentRight:
        {
            imageViewX = CGRectGetWidth(self.frame) - imageViewSize.width - self.imageEdgeInsets.right;
            titleLabelX = CGRectGetWidth(self.frame) - titleLabelSize.width - self.titleEdgeInsets.right;
            
            break;
        }
        case UIControlContentHorizontalAlignmentFill:
        {
            imageViewX = self.imageEdgeInsets.left;
            titleLabelX = self.titleEdgeInsets.left;
            
            break;
        }
        default:
            break;
    }
    
    CGFloat titleLabelY = 0;
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentCenter:
        {
            titleLabelY = (CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.top +
                                                         titleLabelSize.height + self.titleEdgeInsets.bottom)) * 0.5;
            
            break;
        }
        case UIControlContentVerticalAlignmentTop:
        {
            titleLabelY = self.imageEdgeInsets.top;
            
            break;
        }
        case UIControlContentVerticalAlignmentBottom:
        {
            titleLabelY = (CGRectGetHeight(self.frame) - (imageViewSize.height + self.imageEdgeInsets.top + self.imageEdgeInsets.bottom +
                                                         titleLabelSize.height + self.titleEdgeInsets.bottom));
            
            break;
        }
        case UIControlContentVerticalAlignmentFill:
        {
            titleLabelY = self.imageEdgeInsets.top;
            
            break;
        }
        default:
            break;
    }
    
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
    self.imageView.frame = CGRectMake(imageViewX, CGRectGetMaxY(self.titleLabel.frame) + self.imageEdgeInsets.top,
                                      imageViewSize.width,
                                      imageViewSize.height);
}

@end
