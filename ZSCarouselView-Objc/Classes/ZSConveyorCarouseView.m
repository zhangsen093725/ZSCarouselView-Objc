//
//  ZSConveyorCarouseView.m
//  ZSCarouselView-Objc
//
//  Created by Josh on 2022/4/22.
//

#import "ZSConveyorCarouseView.h"
#import "ZSCarouseWeakProxy.h"

static const NSInteger ConveyorSectionCount = 4;
static const NSInteger ConveyorItemMultiple = 1;

@implementation ZSConveyorViewCell

+ (NSString *)zs_identifier {
    
    return NSStringFromClass([self class]);
}

@end


@interface ZSConveyorCarouseView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger elementCount;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGPoint initContentOffset;
@property (nonatomic, assign) CGFloat minimumElementSpacing;
@property (nonatomic, assign) Class cellClass;

@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation ZSConveyorCarouseView

+ (instancetype)new {
    
    return [[self alloc] init];
}

- (instancetype)init {
    
    return [self initWithContentOffset:CGPointZero];
}

- (instancetype)initWithContentOffset:(CGPoint)contentOffset {
    
    if (self = [super init])
    {
        self.initContentOffset = contentOffset;
        self.loopScrollEnable = YES;
        self.autoScrollEnable = YES;
        self.fps = 15;
        self.cellClass = [ZSConveyorViewCell class];
    }
    return self;
}

- (void)dealloc {
    
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)registerClass:(Class)cellClass {
    
    Class superclass = cellClass;
    BOOL isKindOfClass = NO;
    
    while (superclass.superclass != nil)
    {
        if (superclass == [ZSConveyorViewCell class])
        {
            isKindOfClass = YES;
            break;
        }
        superclass = superclass.superclass;
    }
    
    NSAssert(isKindOfClass, @"ZSConveyorViewCell 必须是 cellClass 的 superclass");
    
    self.cellClass = cellClass;
}

- (void)reloadData {
    
    [self.collectionView reloadData];
    self.minimumElementSpacing = [self.dataSource minimumInteritemSpacingInConveyorView:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (self.autoScrollEnable == NO) return;
    
    CGSize newSize = CGSizeFromString(change[NSKeyValueChangeNewKey]);
    
    CGSize oldSize = CGSizeFromString(change[NSKeyValueChangeOldKey]);
    
    if (CGSizeEqualToSize(newSize, oldSize)) return;

    if (newSize.width < 4 * CGRectGetWidth(_collectionView.bounds))
    {
        self.collectionView.contentOffset = self.initContentOffset;
    }
}

// TODO: UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.loopScrollEnable == NO) return;
    
    if (CGSizeEqualToSize(scrollView.contentSize, CGSizeZero)) return;
    
    CGPoint contentOffset = scrollView.contentOffset;
    
    NSInteger count = ConveyorSectionCount * ConveyorItemMultiple;
    CGFloat avgOffset = (scrollView.contentSize.width - _sectionInset.left - _sectionInset.right - (count - 1) * self.minimumElementSpacing) / count;
    
    CGFloat leftBoundary = avgOffset + self.minimumElementSpacing + _sectionInset.left;
    CGFloat rightBoundary = (avgOffset + self.minimumElementSpacing) * (count - 1) + _sectionInset.left;
    
    if (contentOffset.x < leftBoundary)
    {
        CGFloat offset = contentOffset.x - leftBoundary;
        scrollView.contentOffset = CGPointMake(rightBoundary + offset, contentOffset.y);
        return;
    }
    
    if (contentOffset.x > rightBoundary)
    {
        CGFloat offset = contentOffset.x - rightBoundary;
        scrollView.contentOffset = CGPointMake(leftBoundary + offset, contentOffset.y);
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopDisplayLink];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate) return;
    
    [self startDisplayLink];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self startDisplayLink];
}

// TODO: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.loopScrollEnable == NO) return 1;
    
    return ConveyorSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.elementCount = [self.dataSource numberOfItemsInConveyorView:self];
     
    if (self.loopScrollEnable == NO) return self.elementCount;
    
    return ConveyorItemMultiple * self.elementCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSConveyorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[_cellClass zs_identifier] forIndexPath:indexPath];
    
    [self.delegate conveyorView:self cell:cell forItemAtIndex:[self indexForIndexPath:indexPath]];
    
    return cell;
}

// TODO: UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    self.sectionInset = [self.dataSource insetInConveyorView:self];
    
    if (ConveyorSectionCount == 1)
    {
        return self.sectionInset;
    }
    
    if (section == 0)
    {
        return UIEdgeInsetsMake(self.sectionInset.top, self.sectionInset.left, self.sectionInset.bottom, 0);
    }
    
    if (section == ConveyorSectionCount - 1)
    {
        return UIEdgeInsetsMake(self.sectionInset.top, self.minimumElementSpacing, self.sectionInset.bottom, self.sectionInset.right);
    }

    return UIEdgeInsetsMake(self.sectionInset.top, self.minimumElementSpacing, self.sectionInset.bottom, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.dataSource conveyorView:self sizeForItemAtIndex:[self indexForIndexPath:indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.minimumElementSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

// TODO: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    [self.delegate conveyorView:self didSelectItemAtIndex:[self indexForIndexPath:indexPath]];
}

// TODO: Helper
- (void)startDisplayLink {
    
    if (self.autoScrollEnable == NO) return;
    
    if (self.displayLink) return;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:[ZSCarouseWeakProxy proxyWithTarget:self] selector:@selector(autoScroll)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = NO;
    
    if (@available(iOS 10.0, *))
    {
        self.displayLink.preferredFramesPerSecond = _fps;
    }
    else
    {
        self.displayLink.frameInterval = _fps;
    }
}

- (void)stopDisplayLink {
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)autoScroll {
    
    if (CGSizeEqualToSize(self.collectionView.contentSize, CGSizeZero)) return;
    
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat contentOffsetY = self.collectionView.contentOffset.y;
    
    if (_autoScrollDirection == ZSConveyorCarouseViewAutoScrollDirectionLeft)
    {
        contentOffsetX += 0.3;
    }
    else
    {
        contentOffsetX -= 0.3;
    }
    
    self.collectionView.contentOffset = CGPointMake(contentOffsetX, contentOffsetY);
}

// TODO: Getter
- (UICollectionView *)collectionView {
    
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        [self insertSubview:_collectionView atIndex:0];
    }
    return _collectionView;
}

- (NSInteger)indexForIndexPath:(NSIndexPath *)indexPath {
    
    if (_elementCount <= 0) return 0;
    
    return indexPath.item % _elementCount;
}

// TODO: Setter
- (void)setAutoScrollDirection:(ZSConveyorCarouseViewAutoScrollDirection)autoScrollDirection {
    
    _autoScrollDirection = autoScrollDirection;
    
    [self stopDisplayLink];
    [self startDisplayLink];
}

- (void)setCellClass:(Class)cellClass {
    
    _cellClass = cellClass;
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:[cellClass zs_identifier]];
}

- (void)setDataSource:(id<ZSConveyorCarouseViewDataSource>)dataSource {
    
    _dataSource = dataSource;
    self.minimumElementSpacing = [self.dataSource minimumInteritemSpacingInConveyorView:self];
}

- (void)setAutoScrollEnable:(BOOL)autoScrollEnable {
    
    _autoScrollEnable = autoScrollEnable;
    [self stopDisplayLink];
}

- (void)setFps:(NSInteger)fps {
    
    _fps = fps;
    [self stopDisplayLink];
    [self startDisplayLink];
}

@end

