//
//  ZSFocusFlowLayout.m
//  ZSViewUtil-Objc
//
//  Created by Josh on 2022/4/19.
//

#import "ZSFocusFlowLayout.h"

@interface ZSFocusFlowLayout ()

@property (nonatomic, assign) CGFloat _minimumLineSpacing;

@end


@implementation ZSFocusFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 计算出最终显示的矩形框
    CGRect elementRect = CGRectZero;
    
    elementRect.origin = proposedContentOffset;
    elementRect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局的属性
    NSArray *superArray = [super layoutAttributesForElementsInRect:elementRect];
    
    NSMutableArray *superAttributesArray = [NSMutableArray array];
    
    [superArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        [superAttributesArray addObject:[obj copy]];
        
    }];
    
    NSArray *attributes = [superAttributesArray copy];
    
    CGFloat min = MAXFLOAT;
    
    // 计算collectionView最中心点的值
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        CGFloat centerX = proposedContentOffset.x + elementRect.size.width * 0.5;
        
        for (UICollectionViewLayoutAttributes *attribute in attributes)
        {
            if (fabs(min) > fabs(attribute.center.x - centerX))
            {
                min = attribute.center.x - centerX;
            }
        }
        
        elementRect.origin.x += min;
    }
    else
    {
        CGFloat centerY = proposedContentOffset.y + elementRect.size.height * 0.5;
   
        for (UICollectionViewLayoutAttributes *attribute in attributes)
        {
            if (fabs(min) > fabs(attribute.center.y - centerY))
            {
                min = attribute.center.y - centerY;
            }
        }
        
        elementRect.origin.y += min;
    }
    
    return proposedContentOffset;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获得super已经计算好的布局的属性
    NSArray *superArray = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *superAttributesArray = [NSMutableArray array];
    
    [superArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        [superAttributesArray addObject:[obj copy]];
        
    }];
    
    NSArray *attributes = [superAttributesArray copy];

    // 计算collectionView最中心点的值
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
        
        for (UICollectionViewLayoutAttributes *attribute in attributes)
        {
            CGFloat distance = fabs(attribute.center.x - centerX);
            
            CGFloat n = 0;
            CGFloat ratio = 0;
            
            if (distance > 0 && attribute.frame.size.width > 0)
            {
                n = distance / attribute.frame.size.width;
                ratio = (attribute.frame.size.width - 2 * __minimumLineSpacing) / attribute.frame.size.width;
            }
            
            CGFloat toleranceZoom = _focusZoom - ratio;
            CGFloat zoom = _focusZoom - toleranceZoom * n;
            zoom = zoom < 0 ? 0 : zoom;
            
            CGFloat alpha = _focusAlpha - n * _toleranceAlpha;
            alpha = alpha < 0 ? 0 : alpha;
            
            attribute.alpha = alpha;
            attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 5.5);
        }
    }
    else
    {
        CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
        
        for (UICollectionViewLayoutAttributes *attribute in attributes)
        {
            CGFloat distance = fabs(attribute.center.y - centerY);
            
            CGFloat n = 0;
            CGFloat ratio = 0;
            
            if (distance > 0 && attribute.frame.size.height > 0)
            {
                n = distance / attribute.frame.size.height;
                ratio = (attribute.frame.size.height - 2 * __minimumLineSpacing) / attribute.frame.size.height;
            }
            
            CGFloat toleranceZoom = _focusZoom - ratio;
            CGFloat zoom = _focusZoom - toleranceZoom * n;
            zoom = zoom < 0 ? 0 : zoom;
            
            CGFloat alpha = _focusAlpha - n * _toleranceAlpha;
            alpha = alpha < 0 ? 0 : alpha;
            
            attribute.alpha = alpha;
            attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 5.5);
        }
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

// TODO: Setter
- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
    
    __minimumLineSpacing = minimumLineSpacing;
}

@end
