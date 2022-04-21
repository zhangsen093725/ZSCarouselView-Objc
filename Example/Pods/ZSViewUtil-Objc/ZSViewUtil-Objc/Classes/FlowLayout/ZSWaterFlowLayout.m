//
//  ZSWaterFlowLayout.m
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/4/6.
//

#import "ZSWaterFlowLayout.h"

@interface ZSWaterFlowLayout ()
{ // ZSWaterFlowLayoutDataSource
    NSInteger _columnCount;
    CGFloat _minimumSectionSpacing;
}

/// 存放attribute的数组
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributes;

/// 存放每组 section 最后一个长度
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnLenghts;

/// collectionView 的 contentSize 的长度
@property (nonatomic, assign) CGFloat contentLenght;

/// 记录上一组 section 最长一列的长度
@property (nonatomic, assign) CGFloat lastContentLenght;

/// 返回长度最小的一列
@property (nonatomic, assign, readonly) NSInteger minLenghtColumn;

@property (nonatomic, weak, readonly) id<ZSWaterFlowLayoutDelegate> delegate;

@end


@implementation ZSWaterFlowLayout

+ (instancetype)new {
    
    return [[self alloc] init];
}

- (instancetype)init {
    
    if (self = [super init])
    {
        _columnCount = 2;
    }
    return self;
}

- (NSMutableArray<NSNumber *> *)columnLenghts {
    
    if (!_columnLenghts)
    {
        _columnLenghts = [NSMutableArray array];
    }
    
    return _columnLenghts;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributes {
    
    if (!_attributes)
    {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}

- (id<ZSWaterFlowLayoutDelegate>)delegate {
    
    return (id<ZSWaterFlowLayoutDelegate>)self.collectionView.delegate;
}

- (NSInteger)minLenghtColumn {
    
    __block CGFloat min = MAXFLOAT;
    __block NSInteger column = 0;
    
    [self.columnLenghts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (min > obj.floatValue)
        {
            min = obj.floatValue;
            column = idx;
        }
        
    }];
    return column;
}

- (NSInteger)maxLenghtColumn {
    
    __block CGFloat max = 0;
    __block NSInteger column = 0;
    
    [self.columnLenghts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (max > obj.floatValue)
        {
            max = obj.floatValue;
            column = idx;
        }
        
    }];
    return column;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
    self.contentLenght = 0;
    self.lastContentLenght = 0;
    
    [self.columnLenghts removeAllObjects];
    [self.attributes removeAllObjects];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:columnNumberOfSection:)])
        {
            _columnCount = [self.delegate zs_collectionView:self.collectionView flowLayout:self columnNumberOfSection:section];
            _columnCount = _columnCount < 1 ? 1 : _columnCount;
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
        {
            self.sectionInset = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
        {
            self.minimumInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)])
        {
            self.minimumLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)])
        {
            self.headerReferenceSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        }
        
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)])
        {
            self.footerReferenceSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        }
        
        if (section > 0)
        {
            if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:sectionSpacingForSection:)])
            {
                _minimumSectionSpacing = [self.delegate zs_collectionView:self.collectionView flowLayout:self sectionSpacingForSection:section];
            }
        }
        else
        {
            _minimumSectionSpacing = 0;
        }
        
        // 生成header
        if (CGSizeEqualToSize(self.headerReferenceSize, CGSizeZero))
        {
            self.contentLenght += _minimumSectionSpacing;
            self.contentLenght += (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.sectionInset.top : self.sectionInset.left);
        }
        else
        {
            UICollectionViewLayoutAttributes *header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:sectionIndexPath];
            
            if (header != nil)
            {
                [self.attributes addObject:header];
            }
        }
        
        [self.columnLenghts removeAllObjects];
        self.lastContentLenght = self.contentLenght;
        
        // 初始化
        for (NSInteger column = 0; column < _columnCount; column++)
        {
            [self.columnLenghts addObject:@(self.contentLenght)];
        }
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++)
        {
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *cell = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
            
            if (cell != nil)
            {
                [self.attributes addObject:cell];
            }
        }
        
        // 生成footer
        if (CGSizeEqualToSize(self.footerReferenceSize, CGSizeZero))
        {
            self.contentLenght += (self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.sectionInset.bottom : self.sectionInset.right);
        }
        else
        {
            UICollectionViewLayoutAttributes *footer = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:sectionIndexPath];
            
            if (footer != nil)
            {
                [self.attributes addObject:footer];
            }
        }
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    return [self.attributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *cell = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect cellRect = cell.frame;
    CGFloat minColumnLenght = self.columnLenghts[self.minLenghtColumn].floatValue;
    BOOL shouldBeyondSize = NO;
    
    if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:shouldBeyondSizeOfSection:)]) {
        
        shouldBeyondSize = [self.delegate zs_collectionView:self.collectionView flowLayout:self shouldBeyondSizeOfSection:indexPath.section];
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        CGFloat width = CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right - (_columnCount - 1) * self.minimumInteritemSpacing;
        
        CGFloat cellMinimumWidth = width / _columnCount;
        
        CGSize cellSize = [self.delegate zs_collectionView:self.collectionView flowLayout:self minimumSize:CGSizeMake(cellMinimumWidth, MAXFLOAT) sizeForItemAtIndexPath:indexPath];
        
        CGFloat cellWidth = 0;
        CGFloat cellHeight = 0;
        
        CGFloat cellX = 0;
        CGFloat cellY = 0;
        
        if (shouldBeyondSize && cellSize.width > cellMinimumWidth)
        {
            UIEdgeInsets columnInset = UIEdgeInsetsZero;
            
            if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:insetForColumnAtIndex:columnCount:)])
            {
                columnInset = [self.delegate zs_collectionView:self.collectionView flowLayout:self insetForColumnAtIndex:0 columnCount:1];
            }
            
            cellX = self.sectionInset.left + columnInset.left;
            cellWidth = MIN(width - columnInset.right - columnInset.left, cellSize.width);
            cellY = [self.columnLenghts[self.maxLenghtColumn] floatValue] + columnInset.top;
            cellHeight = cellSize.height + columnInset.bottom;
        }
        else
        {
            UIEdgeInsets columnInset = UIEdgeInsetsZero;
            
            if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:insetForColumnAtIndex:columnCount:)])
            {
                columnInset = [self.delegate zs_collectionView:self.collectionView flowLayout:self insetForColumnAtIndex:self.minLenghtColumn columnCount:_columnCount];
            }
            
            cellX = self.sectionInset.left + self.minLenghtColumn * (cellMinimumWidth + self.minimumInteritemSpacing) + columnInset.left;
            cellWidth = MIN(cellMinimumWidth - columnInset.right - columnInset.left, cellSize.width);
            cellY = minColumnLenght + columnInset.top;
            cellHeight = cellSize.height + columnInset.bottom;
        }
        
        if (cellY != self.lastContentLenght)
        {
            cellY += self.minimumLineSpacing;
        }
        
        cellRect = CGRectMake(cellX, cellY, cellWidth, cellHeight);

        if (shouldBeyondSize && cellSize.width > cellMinimumWidth)
        {
            [self.columnLenghts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                [self.columnLenghts replaceObjectAtIndex:idx withObject:@(CGRectGetMaxY(cellRect))];
                
            }];
        }
        else
        {
            [self.columnLenghts replaceObjectAtIndex:self.minLenghtColumn withObject:@(CGRectGetMaxY(cellRect))];
        }
    }
    else
    {
        CGFloat height = CGRectGetHeight(self.collectionView.frame) - self.sectionInset.top - self.sectionInset.bottom - (_columnCount - 1) * self.minimumLineSpacing;
        
        CGFloat cellMinimumHeight = height / _columnCount;
        
        CGSize cellSize = [self.delegate zs_collectionView:self.collectionView flowLayout:self minimumSize:CGSizeMake(MAXFLOAT, cellMinimumHeight) sizeForItemAtIndexPath:indexPath];
        
        CGFloat cellHeight = MIN(cellMinimumHeight, cellSize.height);
        CGFloat cellWidth = cellSize.width;
        
        CGFloat cellY = self.sectionInset.top + self.minLenghtColumn * (cellMinimumHeight + self.minimumLineSpacing);
        
        CGFloat cellX = minColumnLenght;
        
        if (shouldBeyondSize && cellSize.width > cellMinimumHeight)
        {
            UIEdgeInsets columnInset = UIEdgeInsetsZero;
            
            if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:insetForColumnAtIndex:columnCount:)])
            {
                columnInset = [self.delegate zs_collectionView:self.collectionView flowLayout:self insetForColumnAtIndex:0 columnCount:1];
            }
            
            cellHeight = MIN(height - columnInset.bottom - columnInset.top, cellSize.height);
            cellY = self.sectionInset.top + columnInset.top;
            cellX = [self.columnLenghts[self.maxLenghtColumn] floatValue] + columnInset.left;
            cellWidth = cellSize.width + columnInset.right;
        }
        else
        {
            UIEdgeInsets columnInset = UIEdgeInsetsZero;
            
            if ([self.delegate respondsToSelector:@selector(zs_collectionView:flowLayout:insetForColumnAtIndex:columnCount:)])
            {
                columnInset = [self.delegate zs_collectionView:self.collectionView flowLayout:self insetForColumnAtIndex:self.minLenghtColumn columnCount:_columnCount];
            }
            
            cellHeight = MIN(cellMinimumHeight - columnInset.bottom - columnInset.top, cellSize.height);
            cellY = self.sectionInset.top + self.minLenghtColumn * (cellMinimumHeight + self.minimumLineSpacing) + columnInset.top;
            cellX = minColumnLenght + columnInset.left;
            cellWidth = cellSize.width + columnInset.right;
        }
        
        if (cellX != self.lastContentLenght)
        {
            cellX += self.minimumInteritemSpacing;
        }
        
        cellRect = CGRectMake(cellX, cellY, cellWidth, cellHeight);

        if (shouldBeyondSize && cellSize.height > cellMinimumHeight)
        {
            [self.columnLenghts enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                [self.columnLenghts replaceObjectAtIndex:idx withObject:@(CGRectGetMaxX(cellRect))];
            }];
        }
        else
        {
            [self.columnLenghts replaceObjectAtIndex:self.minLenghtColumn withObject:@(CGRectGetMaxX(cellRect))];
        }
    }
    
    if (self.contentLenght < minColumnLenght)
    {
        self.contentLenght = minColumnLenght;
    }
    
    //取最大的
    for (NSNumber *vaule in self.columnLenghts)
    {
        if (self.contentLenght < vaule.floatValue)
        {
            self.contentLenght = vaule.floatValue;
        }
    }
    
    cell.frame = cellRect;
    
    return cell;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *supplementaryView = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        self.contentLenght += _minimumSectionSpacing;
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            supplementaryView.frame = CGRectMake(0, self.contentLenght, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentLenght += self.headerReferenceSize.height;
            self.contentLenght += self.sectionInset.top;
        }
        else
        {
            supplementaryView.frame = CGRectMake(self.contentLenght, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
            self.contentLenght += self.headerReferenceSize.width;
            self.contentLenght += self.sectionInset.left;
        }
    }
    else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            self.contentLenght += self.sectionInset.bottom;
            supplementaryView.frame = CGRectMake(0, self.contentLenght, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentLenght += self.footerReferenceSize.height;
        }
        else
        {
            self.contentLenght += self.sectionInset.right;
            supplementaryView.frame = CGRectMake(self.contentLenght, 0, self.footerReferenceSize.width, self.footerReferenceSize.height);
            self.contentLenght += self.footerReferenceSize.width;
        }
    }
    return supplementaryView;
}


- (CGSize)collectionViewContentSize {
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        return CGSizeMake(0, self.contentLenght);
    }
    else
    {
        return CGSizeMake(self.contentLenght, 0);
    }
}

@end
