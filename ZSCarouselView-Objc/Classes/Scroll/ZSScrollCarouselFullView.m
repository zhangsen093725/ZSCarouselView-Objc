//
//  ZSScrollCarouselFullView.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselFullView.h"

@implementation ZSScrollCarouselFullView

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    
    return [self initWithScrollDirection:scrollDirection cellClass:[ZSScrollCarouselCell class]];
}

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)scrollDirection cellClass:(Class)cellClass {
    
    if (self = [super init])
    {
        self.collectionViewLayout.scrollDirection = scrollDirection;
        self.cellClass = cellClass;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    if (isHorizontal)
    {
        self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) + self.minimumSpacing, CGRectGetHeight(self.bounds));
    }
    else
    {
        self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + self.minimumSpacing);
    }
}

- (void)calculationLoopScrollOffset {
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    if (isHorizontal)
    {
        NSInteger contentOffsetX = self.collectionView.contentOffset.x;
        NSInteger itemWidth = self.collectionViewLayout.itemSize.width;
        
        if (self.collectionView.contentOffset.x <= 0)
        {
            [self.collectionView setContentOffset:CGPointMake(self.collectionViewLayout.itemSize.width * self.itemCount, 0) animated:NO];
        }
        else if (contentOffsetX >= itemWidth * (self.loopScrollItemCount - 1))
        {
            [self.collectionView setContentOffset:CGPointMake(self.collectionViewLayout.itemSize.width, 0) animated:NO];
        }
    }
    else
    {
        NSInteger contentOffsetY = self.collectionView.contentOffset.y;
        NSInteger itemHeight = self.collectionViewLayout.itemSize.height;
        
        if (self.collectionView.contentOffset.y <= 0)
        {
            [self.collectionView setContentOffset:CGPointMake(0 , self.collectionViewLayout.itemSize.height * self.itemCount) animated:NO];
        }
        else if (contentOffsetY >= itemHeight * (self.loopScrollItemCount - 1))
        {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionViewLayout.itemSize.height) animated:NO];
        }
    }
}

- (NSInteger)calculationPage {
    
    CGFloat width = self.collectionViewLayout.itemSize.width;
    CGFloat height = self.collectionViewLayout.itemSize.height;
    
    CGFloat offsetX = self.collectionViewLayout.itemSize.width * 0.5 + self.collectionView.contentOffset.x;
    CGFloat offsetY = self.collectionViewLayout.itemSize.height * 0.5 + self.collectionView.contentOffset.y;
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    return (isHorizontal ? offsetX / width : offsetY / height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isLoopScroll)
    {
        [self calculationLoopScrollOffset];
    }
    
    NSInteger currentPage = [self calculationPage];
    
    if (currentPage == self.cachePage) return;
  
    self.cachePage = currentPage;
    
    if (self.isLoopScroll)
    {
        if (currentPage == self.loopScrollItemCount - 1) return;
        if (currentPage == 0) return;
        
        [self.delegate zs_carouseViewDidScroll:self index:currentPage - 1];
    }
    else
    {
        if (currentPage == self.itemCount - 1) return;
        [self.delegate zs_carouseViewDidScroll:self index:currentPage];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ZSScrollCarouselCell class]])
    {
        ZSScrollCarouselCell *__cell = (ZSScrollCarouselCell *)cell;
        
        BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
        
        if (isHorizontal)
        {
            __cell.minimumInteritemSpacing = _minimumSpacing;
            __cell.minimumLineSpacing = 0;
        }
        else
        {
            __cell.minimumInteritemSpacing = 0;
            __cell.minimumLineSpacing = _minimumSpacing;
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = collectionView.bounds.size;
    
    self.collectionViewLayout.itemSize = itemSize;
    
    return itemSize;
}

@end
