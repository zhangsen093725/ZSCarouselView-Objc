//
//  ZSScrollCarouselViewController.m
//  ZSCarouselView-Objc_Example
//
//  Created by Josh on 2022/4/20.
//  Copyright © 2022 Josh. All rights reserved.
//

#import "ZSScrollCarouselViewController.h"
#import "ZSScrollCarouselCustomView.h"
#import "ZSScrollCarouselFullView.h"
#import "ZSFocusFlowLayout.h"

@interface ZSScrollCarouselViewController ()<ZSScrollCarouselViewDelegate, ZSScrollCarouselViewDataSource>

@property (nonatomic, strong) ZSScrollCarouselCustomView *carouseCustomView;
@property (nonatomic, strong) ZSScrollCarouselFullView *carouseFullView;

@end

@implementation ZSScrollCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.carouseFullView.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 300) * 0.5, 75, 300, 150);
    self.carouseCustomView.frame = CGRectMake(0, CGRectGetMaxY(self.carouseFullView.frame) + 40, CGRectGetWidth(self.view.frame), 228);
}

/// 滚动视图的总数
/// @param carouseView carouseView
- (NSInteger)zs_numberOfItemcarouseView:(ZSScrollCarouselView *)carouseView {
    
    return self.imageFiles.count;
}

/// 滚动到的视图
/// @param cell 当前的carouseCell
/// @param index 当前的index
- (void)zs_configCarouseCell:(ZSScrollCarouselCell *)cell itemAtIndex:(NSInteger)index {
    
    
    cell.backgroundColor = [UIColor brownColor];
}

/// 滚动视图Item的点击
/// @param carouseView carouseView
/// @param index 当前的index
- (void)zs_carouseView:(ZSScrollCarouselView *)carouseView didSelectedItemForIndex:(NSInteger)index {
    
    
}

/// 滚动视图的回调
/// @param carouseView carouseView
/// @param index 当前的index
- (void)zs_carouseViewDidScroll:(ZSScrollCarouselView *)carouseView index:(NSInteger)index {
    
}


// TODO: Getter
- (NSArray *)imageFiles {
    
    return @[@"http://ww1.sinaimg.cn/large/b02ee545gy1gdmhz2191mj205603rt8j.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gdnhcee791j2048097dfs.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg85m29vyaj218m0g8ju4.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg85iftrngj20wc0b40vc.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg85p8ub1ij217818mds9.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg85qvp173j21cw1v2apj.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg85sa4lsuj20zg0buta4.jpg",
             @"http://ww1.sinaimg.cn/large/b02ee545gy1gg8wst5idmj21us0xedki.jpg"];
}

- (ZSScrollCarouselCustomView *)carouseCustomView {
    
    if (!_carouseCustomView)
    {
        ZSFocusFlowLayout *layout = [ZSFocusFlowLayout new];
        layout.focusZoom = 1;
        layout.focusAlpha = 1;
        layout.toleranceAlpha = 0.5;
        layout.minimumLineSpacing = 24;
        layout.itemSize = CGSizeMake(255, 228);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _carouseCustomView = [[ZSScrollCarouselCustomView alloc] initWithCollectionViewLayout:layout];
        _carouseCustomView.delegate = self;
        _carouseCustomView.dataSource = self;
        _carouseCustomView.loopScroll = YES;
        [self.view addSubview:_carouseCustomView];
    }
    return _carouseCustomView;
}

- (ZSScrollCarouselFullView *)carouseFullView {
    
    if (!_carouseFullView)
    {
        _carouseFullView = [[ZSScrollCarouselFullView alloc] initWithScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _carouseFullView.delegate = self;
        _carouseFullView.dataSource = self;
        _carouseFullView.minimumSpacing = 10;
        [self.view addSubview:_carouseFullView];
    }
    return _carouseFullView;
}

@end
