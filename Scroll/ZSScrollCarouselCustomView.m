//
//  ZSScrollCarouselCustomView.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselCustomView.h"

@interface ZSScrollCarouselCustomView ()

@property (nonatomic, assign, getter=isBeginDragging) BOOL beginDragging;

@end


@implementation ZSScrollCarouselCustomView

- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout {
    
    return [self initWithCollectionViewLayout:collectionViewLayout cellClass:[ZSScrollCarouselCell class]];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)collectionViewLayout cellClass:(Class)cellClass {
    
    if (self = [super init])
    {
        self.collectionViewLayout = collectionViewLayout;
        self.cellClass = cellClass;
    }
    return self;
}

- (void)configCollectionView:(UICollectionView *)collectionView {
    
    [super configCollectionView:collectionView];
    collectionView.pagingEnabled = NO;
}

- (void)calculationLoopScrollOffset {
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    if (isHorizontal)
    {
        if (self.collectionView.contentOffset.x <= 0)
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            
            if (cell == nil) return;
            
            CGFloat offset = self.collectionView.contentSize.width - cell.frame.size.width - self.collectionViewLayout.itemSize.width - self.collectionViewLayout.minimumLineSpacing;
            [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
            
            if (self.isBeginDragging == NO)
            {
                [self scrollViewWillBeginDecelerating:self.collectionView];
            }
        }
        else if (self.collectionView.contentOffset.x >= self.collectionView.contentSize.width - CGRectGetWidth(self.collectionView.frame))
        {
            UICollectionViewCell *pre = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.loopScrollItemCount - 2 inSection:0]];
            UICollectionViewCell *next = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.loopScrollItemCount - 1 inSection:0]];
            
            if (pre == nil || next == nil) return;
            
            CGFloat offset = self.collectionView.contentOffset.x - pre.frame.origin.x + (next.frame.origin.x - CGRectGetMaxX(pre.frame));
            [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
            
            if (self.isBeginDragging == NO)
            {
                [self scrollViewWillBeginDecelerating:self.collectionView];
            }
        }
    }
    else
    {
        if (self.collectionView.contentOffset.y <= 0)
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            
            if (cell == nil) return;
            
            CGFloat offset = self.collectionView.contentSize.height - cell.frame.size.height - self.collectionViewLayout.itemSize.height - self.collectionViewLayout.minimumLineSpacing;
            [self.collectionView setContentOffset:CGPointMake(0, offset) animated:NO];
            
            if (self.isBeginDragging == NO)
            {
                [self scrollViewWillBeginDecelerating:self.collectionView];
            }
        }
        else if (self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - CGRectGetHeight(self.collectionView.frame))
        {
            UICollectionViewCell *pre = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.loopScrollItemCount - 2 inSection:0]];
            UICollectionViewCell *next = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.loopScrollItemCount - 1 inSection:0]];
            
            if (pre == nil || next == nil) return;

            CGFloat offset = self.collectionView.contentOffset.y - pre.frame.origin.y + (next.frame.origin.y - CGRectGetMaxY(pre.frame));
            [self.collectionView setContentOffset:CGPointMake(0, offset) animated:NO];
            
            if (self.isBeginDragging == NO)
            {
                [self scrollViewWillBeginDecelerating:self.collectionView];
            }
        }
    }
}

- (NSInteger)calculationPage {
    
    CGFloat xx = (CGRectGetWidth(self.collectionView.frame) - self.collectionViewLayout.itemSize.width) * 0.5;
    CGFloat yy = (CGRectGetHeight(self.collectionView.frame) - self.collectionViewLayout.itemSize.height) * 0.5;
    
    CGFloat width = self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing;
    CGFloat height = self.collectionViewLayout.itemSize.height + self.collectionViewLayout.minimumLineSpacing;
    
    CGFloat offsetX = xx + self.collectionView.contentOffset.x;
    CGFloat offsetY = yy + self.collectionView.contentOffset.y;
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    return (isHorizontal ? offsetX / width : offsetY / height) + 0.5;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [super scrollViewWillBeginDragging:scrollView];
    
    _beginDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    _beginDragging = NO;
    [self scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    CGFloat currentPage = [self calculationPage];
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewScrollPosition position = isHorizontal ?
    UICollectionViewScrollPositionCenteredHorizontally :
    UICollectionViewScrollPositionCenteredVertically;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0] atScrollPosition:position animated:YES];
}

@end
