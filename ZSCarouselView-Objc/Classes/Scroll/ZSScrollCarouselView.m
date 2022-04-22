//
//  ZSScrollCarouselView.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/20.
//

#import "ZSScrollCarouselView.h"
#import "NSTimer+ZSCarousel.h"

@interface ZSScrollCarouselView ()

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) NSInteger loopScrollItemCount;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation ZSScrollCarouselView

+ (instancetype)new {
    
    return [[self alloc] init];
}

- (instancetype)init {
 
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        self.cachePage = 1;
        self.interval = 3;
        
        self.autoScroll = YES;
        self.loopScroll = YES;
        
        self.cellClass = [ZSScrollCarouselCell class];
        self.collectionViewLayout = [UICollectionViewFlowLayout new];
    }
    return self;
}

- (void)dealloc {
    
    [self endAutoScroll];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    if (self.isLoopScroll)
    {
        if (CGRectEqualToRect(self.collectionView.frame, CGRectZero)) return;
        
        [self reloadData];
        [_collectionView layoutIfNeeded];
        
        BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
        
        UICollectionViewScrollPosition position = isHorizontal ?
        UICollectionViewScrollPositionCenteredHorizontally :
        UICollectionViewScrollPositionCenteredVertically;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.cachePage inSection:0] atScrollPosition:position animated:NO];
        });
    }
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
 
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)configCollectionView:(UICollectionView *)collectionView {
    
    collectionView.pagingEnabled = YES;
    [self registerClass:_cellClass forCellWithReuseIdentifier:[_cellClass zs_identifier]];
}

- (void)reloadData {
    
    [_collectionView reloadData];
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
    
    NSInteger index = page;
    
    if (self.isLoopScroll)
    {
        if (page >= _loopScrollItemCount) return;
        
        index = page + 1;
        index = page == _loopScrollItemCount - 1 ? _itemCount : index;
        index = page == 0 ? 1 : index;
    }
    else if (page >= _itemCount) return;
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewScrollPosition position = isHorizontal ?
    UICollectionViewScrollPositionCenteredHorizontally :
    UICollectionViewScrollPositionCenteredVertically;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:position animated:animated];
}

- (void)beginAutoScroll {
    
    if (self.isAutoScroll == NO) return;
    
    if (_timer) return;
    
    _timer = [NSTimer zs_carouse_supportiOS_10EarlierTimer:_interval repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [self autoScroll];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)endAutoScroll {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)autoScroll {
    
    NSInteger page = _cachePage + 1;
    
    if (self.isLoopScroll)
    {
        if (page >= _loopScrollItemCount) return;
    }
    else
    {
        if (page >= _itemCount)
        {
            [self endAutoScroll];
            return;
        }
    }
    
    BOOL isHorizontal = self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewScrollPosition position = isHorizontal ?
    UICollectionViewScrollPositionCenteredHorizontally :
    UICollectionViewScrollPositionCenteredVertically;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:position animated:YES];
}

- (NSInteger)scrollCarouseIndexFromPage:(NSInteger)page {
    
    NSInteger index = page + 1;
    
    if (self.isLoopScroll && _loopScrollItemCount > 0)
    {
        index = page == _loopScrollItemCount - 1 ? 1 : page;
        index = page == 0 ? _itemCount : index;
    }
    return index - 1;
}

// TODO: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endAutoScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self beginAutoScroll];
}

// TODO: UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    _itemCount = [self.dataSource zs_numberOfItemcarouseView:self];
    _loopScrollItemCount = _itemCount + 2;
    
    return self.isLoopScroll ? _loopScrollItemCount : _itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = [self.dataSource zs_carouseView:self dequeueReusableCellWithReuseIdentifierAtIndex:[self scrollCarouseIndexFromPage:indexPath.item]];
    
    if (reuseIdentifier.length <= 0)
    {
        reuseIdentifier = [_cellClass zs_identifier];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self.delegate zs_configCarouseCell:cell itemAtIndex:[self scrollCarouseIndexFromPage:indexPath.item]];
    
    return cell;
}

// TODO: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate zs_carouseView:self didSelectedItemForIndex:[self scrollCarouseIndexFromPage:indexPath.item]];
}

// TODO: Getter
- (UICollectionView *)collectionView {
    
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [self configCollectionView:_collectionView];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

// TODO: Setter
- (void)setLoopScroll:(BOOL)loopScroll {
    
    _loopScroll = loopScroll;
    [self reloadData];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    
    _autoScroll = autoScroll;
    autoScroll ? [self beginAutoScroll] : [self endAutoScroll];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    
    _contentInset = contentInset;
    self.collectionView.contentInset = contentInset;
    [self reloadData];
}

@end
