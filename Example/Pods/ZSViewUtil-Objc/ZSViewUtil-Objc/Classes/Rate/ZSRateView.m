//
//  ZSRateView.m
//  ZSViewUtil-Objc
//
//  Created by Josh on 2021/3/29.
//

#import "ZSRateView.h"
#import "ZSRateCollectionViewCell.h"

@interface ZSRateView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation ZSRateView

- (instancetype)init {
    
    if (self = [super init])
    {
        self.selectedIndex = 5;
        self.count = 5;
        self.progressEnable = YES;
    }
    return self;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ZSRateCollectionViewCell class] forCellWithReuseIdentifier:[ZSRateCollectionViewCell zs_identifier]];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (CGSize)intrinsicContentSize {
    
    return [self.collectionView contentSize];
}

- (void)setProgressEnable:(BOOL)progressEnable {
    
    _progressEnable = progressEnable;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(CGFloat)selectedIndex {
    
    _selectedIndex = selectedIndex;
    [self.collectionView reloadData];
}

- (void)setCount:(NSInteger)count {
    
    _count = count;
    [self.collectionView reloadData];
}

- (void)setMargin:(UIEdgeInsets)margin {
    
    _margin = margin;
    [self.collectionView reloadData];
}

- (void)setMinimumSpacing:(CGFloat)minimumSpacing {
    
    _minimumSpacing = minimumSpacing;
    [self.collectionView reloadData];
}

// TODO: UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSRateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZSRateCollectionViewCell zs_identifier] forIndexPath:indexPath];

    CGFloat progress = 0;
    
    if (self.isProgressEnable)
    {
        progress = self.selectedIndex - indexPath.item;
    }
    else if ((NSInteger)self.selectedIndex - 1 == indexPath.item)
    {
        progress = 1;
    }
    
    UIImage *imageNormal = [self.dataSource ty_rateView:self itemImageNormalForIndex:indexPath.item];
    UIImage *imageSelected = [self.dataSource ty_rateView:self itemImageSelectedForIndex:indexPath.item];
    
    [cell reloadImageNormal:imageNormal
              imageSelected:imageSelected
           selectedProgress:progress];
    
    return cell;
}

// TODO: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.dataSource ty_rateView:self itemSizeForIndex:indexPath.item];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.minimumSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return self.margin;
}

// TODO: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.item + 1;
    
    [self.delegate ty_rateView:self didSelectedItemForIndex:self.selectedIndex];
}

@end
