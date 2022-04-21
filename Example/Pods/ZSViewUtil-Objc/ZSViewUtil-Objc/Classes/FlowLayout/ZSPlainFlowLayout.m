//
//  ZSPlainFlowLayout.m
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import "ZSPlainFlowLayout.h"

@implementation ZSPlainFlowLayout

+ (instancetype)new {
    
    return [[self alloc] init];
}

- (instancetype)init {
    
    if (self = [super init])
    {
        self.plainOffset = 64.0;
        self.plainSection = NSNotFound;
    }
    return self;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *superArray = [super layoutAttributesForElementsInRect:rect];
    
    if (self.sectionHeadersPinToVisibleBounds == YES) { return superArray; }
    
    NSMutableArray *superAttributesArray = [NSMutableArray array];
    
    [superArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        [superAttributesArray addObject:[obj copy]];
        
    }];
    
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    
    //遍历数组，把所有没有header的section加入数组。
    for (UICollectionViewLayoutAttributes *attribute in superAttributesArray)
    {
        if (attribute.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attribute.indexPath.section];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attribute in superAttributesArray)
    {
        // 如果当前的元素是一个header，将header所在的section从数组中移除
        if (attribute.representedElementKind == UICollectionElementKindSectionHeader)
        {
            [noneHeaderSections removeIndex:attribute.indexPath.section];
        }
    }
    
    //把离开屏幕被系统回收的section重新加到数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * _Nonnull stop) {
       
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        if (attribute)
        {
            [superAttributesArray addObject:[attribute copy]];
        }
        
    }];
    
    for (UICollectionViewLayoutAttributes *attribute in [superAttributesArray copy])
    {
        if([attribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            NSInteger section = attribute.indexPath.section;
            
            //获取第一个跟最后一个item的信息
            NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            
            //判断是否全选，或者指定那个section悬浮
            NSInteger numberOfItemsInSection = 0;
            if (attribute.indexPath.section == _plainSection || _plainSection == NSNotFound)
            {
                numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attribute.indexPath.section];
                NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection - 1) inSection:section];
                
                UICollectionViewLayoutAttributes *firstItemAttributes;
                UICollectionViewLayoutAttributes *lastItemAttributes;
                
                if (numberOfItemsInSection > 0)
                {
                    firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
                    lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
                }
                else
                {
                    firstItemAttributes = [[UICollectionViewLayoutAttributes alloc] init];
                    
                    CGFloat itemY = CGRectGetMaxY(attribute.frame) + self.sectionInset.top;
                    firstItemAttributes.frame = CGRectMake(0, itemY , 0, 0);
                    
                    lastItemAttributes = firstItemAttributes;
                }
                
                CGRect headerRect = attribute.frame;
                //滑动到那个地方停止
                CGFloat offSet = self.collectionView.contentOffset.y + _plainOffset;
                
                //改变header的frame
                CGFloat headerY = firstItemAttributes.frame.origin.y - headerRect.size.height - self.sectionInset.top;
                CGFloat maxY = MAX(offSet, headerY);
                CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - headerRect.size.height;
                headerRect.origin.y = MIN(maxY, headerMissingY);
                
                attribute.frame = headerRect;
                attribute.zIndex = 1024;
            }
        }
    }
    return [superAttributesArray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
}

@end
