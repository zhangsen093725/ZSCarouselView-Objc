//
//  ZSFixedSpecingFlowLayout.m
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/26.
//

#import "ZSFixedSpecingFlowLayout.h"

@interface ZSFixedSpecingFlowLayout ()

@property (nonatomic, assign) ZSFixedSpecingAlignment alignment;

@property (nonatomic, assign) BOOL isLineBreakByClipping;

@end


@implementation ZSFixedSpecingFlowLayout

- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping {
    
    return [self initWithAlignment:alignment
             isLineBreakByClipping:isLineBreakByClipping
                  interitemSpacing:0];
}

- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping
                 interitemSpacing:(CGFloat)interitemSpacing {
    
    return [self initWithAlignment:alignment
             isLineBreakByClipping:isLineBreakByClipping
                  interitemSpacing:interitemSpacing
                      sectionInset:UIEdgeInsetsZero];
}

- (instancetype)initWithAlignment:(ZSFixedSpecingAlignment)alignment
            isLineBreakByClipping:(BOOL)isLineBreakByClipping
                 interitemSpacing:(CGFloat)interitemSpacing
                     sectionInset:(UIEdgeInsets)sectionInset {
    
    if (self = [super init])
    {
        self.alignment = alignment;
        self.isLineBreakByClipping = isLineBreakByClipping;
        self.minimumInteritemSpacing = interitemSpacing;
        self.sectionInset = sectionInset;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}





- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat maxWidth = (CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right);
    
    UICollectionViewLayoutAttributes *firstObject = attributes.firstObject;
    
    if (self.isLineBreakByClipping &&
        CGRectGetMaxX(firstObject.frame) > maxWidth) return @[];
    
    /// 左对齐布局
    NSMutableArray *subAttributes = [NSMutableArray array];
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.representedElementCategory != UICollectionElementCategoryCell) return;
        
        UICollectionViewLayoutAttributes *pre = idx > 0 ? attributes[idx - 1] : nil;
        
        CGRect frame = obj.frame;
        
        /// 同一行的 Cell 修改 frame
        if (CGRectGetMinY(pre.frame) == CGRectGetMinY(obj.frame) && pre != nil)
        {
            frame.origin.x = CGRectGetMaxX(pre.frame) + self.minimumInteritemSpacing;
        }
        /// 每行的第一个
        else
        {
            /// UICollectionView 不可滑动时
            if (self.collectionView.isScrollEnabled == NO)
            {
                /// 超出可见区域部分不做处理
                if (CGRectGetMaxY(obj.frame) + self.sectionInset.bottom > CGRectGetHeight(self.collectionView.frame))
                {
                    /// 尾行最后一个 Item 不舍弃时，限定最后一个 Item 的宽度为可见区域最大宽度
                    if (self.isLineBreakByClipping == NO)
                    {
                        CGFloat width = CGRectGetWidth(self.collectionView.frame) - CGRectGetMinX(frame) - self.sectionInset.right;
                        
                        /// 保障最小的宽度
                        if (width > 20)
                        {
                            frame.origin.y = CGRectGetMinY(pre.frame);
                            frame.origin.x = CGRectGetMaxX(pre.frame) + self.minimumInteritemSpacing;
                            frame.size.width = width;
                            
                            obj.frame = frame;
                            [subAttributes addObject:[obj copy]];
                        }
                    }
                    
                    *stop = YES;
                    return;
                }
            }
            
            frame.origin.x = self.sectionInset.left;
        }
        
        obj.frame = frame;
        [subAttributes addObject:[obj copy]];
    }];
    
    switch (self.alignment)
    {
        case ZSFixedSpecingAlignmentLeft: return [subAttributes copy]; 
        case ZSFixedSpecingAlignmentRight:
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            
            __block NSInteger preIndex = 0;
            
            [subAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UICollectionViewLayoutAttributes *pre = idx > 0 ? subAttributes[idx - 1] : nil;
                
                /// 上一行的右对齐
                if (CGRectGetMinY(pre.frame) != CGRectGetMinY(obj.frame) && pre != nil)
                {
                    NSArray *subArray = [self cellsAlignmentRightFromAttributes:subAttributes
                                                                          range:NSMakeRange(preIndex, idx + 1 - preIndex)];
                    
                    preIndex = idx;
                    [tempArray addObjectsFromArray:subArray];
                }
                /// 最后一行的右对齐
                else  if (idx == subAttributes.count - 1)
                {
                    NSArray *subArray = [self cellsAlignmentRightFromAttributes:subAttributes
                                                                          range:NSMakeRange(preIndex, subAttributes.count - preIndex)];
                    [tempArray addObjectsFromArray:subArray];
                }
                
            }];
            
            return [tempArray copy];
        }
        case ZSFixedSpecingAlignmentCenter:
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            
            __block NSInteger preIndex = 0;
            
            [subAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                UICollectionViewLayoutAttributes *pre = idx > 0 ? subAttributes[idx - 1] : nil;

                /// 上一行的居中布局
                if (CGRectGetMinY(pre.frame) != CGRectGetMinY(obj.frame) && pre != nil)
                {
                    NSArray *subArray = [self cellsAlignmentCenterFromAttributes:subAttributes
                                                                        lastCell:pre
                                                                           range:NSMakeRange(preIndex, idx + 1 - preIndex)];
                    
                    preIndex = idx;
                    [tempArray addObjectsFromArray:subArray];
                }
                /// 最后一行的居中布局
                else if (idx == subAttributes.count - 1)
                {
                    NSArray *subArray = [self cellsAlignmentCenterFromAttributes:subAttributes
                                                                        lastCell:obj
                                                                           range:NSMakeRange(preIndex, subAttributes.count - preIndex)];
                    [tempArray addObjectsFromArray:subArray];
                }
            }];
            
            return [tempArray copy];
        }
    }
}

- (NSArray *)cellsAlignmentRightFromAttributes:(NSArray *)attributes range:(NSRange)range  {
    
    NSArray <UICollectionViewLayoutAttributes *>*subArray = [[[attributes subarrayWithRange:range] reverseObjectEnumerator] allObjects];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [subArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*_Nonnull obj, NSUInteger indx, BOOL * _Nonnull stop) {
        
        UICollectionViewLayoutAttributes *pre = indx > 0 ? subArray[indx - 1] : nil;
        
        CGRect frame = obj.frame;
        
        /// 同一行的 Cell 修改 frame
        if (CGRectGetMinY(pre.frame) == CGRectGetMinY(obj.frame) && pre != nil)
        {
            frame.origin.x = CGRectGetMinX(pre.frame) - CGRectGetWidth(obj.frame) - self.minimumInteritemSpacing;
        }
        /// 修改每行第一个 Cell 的 frame
        else
        {
            frame.origin.x = CGRectGetMaxX(self.collectionView.frame) - CGRectGetWidth(obj.frame) - self.sectionInset.right;
        }
        
        obj.frame = frame;
        [tempArray addObject:obj];
    }];
    
    return [tempArray copy];
}

- (NSArray *)cellsAlignmentCenterFromAttributes:(NSArray *)attributes lastCell:(UICollectionViewLayoutAttributes *)lastCell range:(NSRange)range  {
    
    CGFloat x = (CGRectGetWidth(self.collectionView.frame) + self.sectionInset.left - CGRectGetMaxX(lastCell.frame)) * 0.5;
    
    NSArray <UICollectionViewLayoutAttributes *>*subArray = [attributes subarrayWithRange:range];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [subArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*_Nonnull obj, NSUInteger indx, BOOL * _Nonnull stop) {
        
        UICollectionViewLayoutAttributes *pre = indx > 0 ? subArray[indx - 1] : nil;
        
        CGRect frame = obj.frame;
        
        /// 同一行的 Cell 修改 frame
        if (CGRectGetMinY(pre.frame) == CGRectGetMinY(obj.frame) && pre != nil)
        {
            frame.origin.x = CGRectGetMaxX(pre.frame) + self.minimumInteritemSpacing;
        }
        /// 修改每行第一个 Cell 的 frame
        else
        {
            frame.origin.x = x;
        }
        
        obj.frame = frame;
        [tempArray addObject:obj];
    }];
    
    return [tempArray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
