//
//  ZSCollectionView.m
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import "ZSCollectionView.h"

@implementation ZSCollectionView

- (void)setCollectionViewTopView:(UIView *)collectionViewTopView {
    
    if (_collectionViewTopView == collectionViewTopView) { return; }
    [_collectionViewTopView removeFromSuperview];
    
    _collectionViewTopView = collectionViewTopView;
    
    if (_collectionViewTopView == nil)
    {
        UIEdgeInsets tempInset = self.contentInset;
        tempInset.top = 0;
        self.contentInset = tempInset;
    }
    else
    {
        [self addSubview:_collectionViewTopView];
    }
}

- (void)setCollectionViewBottomView:(UIView *)collectionViewBottomView {
    
    if (_collectionViewBottomView == collectionViewBottomView) { return; }
    [_collectionViewBottomView removeFromSuperview];
    
    _collectionViewBottomView = collectionViewBottomView;
    
    if (_collectionViewBottomView == nil)
    {
        UIEdgeInsets tempInset = self.contentInset;
        tempInset.bottom = 0;
        self.contentInset = tempInset;
    }
    else
    {
        [self addSubview:_collectionViewBottomView];
    }
}

- (void)setCollectionViewLeftView:(UIView *)collectionViewLeftView {
    
    if (_collectionViewLeftView == collectionViewLeftView) { return; }
    [_collectionViewLeftView removeFromSuperview];
    
    _collectionViewLeftView = collectionViewLeftView;
    
    if (_collectionViewLeftView == nil)
    {
        UIEdgeInsets tempInset = self.contentInset;
        tempInset.left = 0;
        self.contentInset = tempInset;
    }
    else
    {
        [self addSubview:_collectionViewLeftView];
    }
}

- (void)setCollectionViewRightView:(UIView *)collectionViewRightView {
    
    if (_collectionViewRightView == collectionViewRightView) { return; }
    [_collectionViewRightView removeFromSuperview];
    
    _collectionViewRightView = collectionViewRightView;
    
    if (_collectionViewRightView == nil)
    {
        UIEdgeInsets tempInset = self.contentInset;
        tempInset.right = 0;
        self.contentInset = tempInset;
    }
    else
    {
        [self addSubview:_collectionViewRightView];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutTopView];
    [self layoutBottomView];
    [self layoutLeftView];
    [self layoutRightView];
}

- (void)reloadData {
    
    [super reloadData];
    [self layoutTopView];
    [self layoutBottomView];
    [self layoutLeftView];
    [self layoutRightView];
}

- (void)layoutTopView {
    
    if (_collectionViewTopView == nil) { return; }
    
    CGFloat topHeight = CGRectGetHeight(_collectionViewTopView.frame);
    
    _collectionViewTopView.frame = CGRectMake(0, -topHeight, CGRectGetWidth(self.frame), topHeight);
    
    UIEdgeInsets tempInset = self.contentInset;
    tempInset.top = topHeight;
    self.contentInset = tempInset;
}

- (void)layoutBottomView {
    
    if (_collectionViewBottomView == nil) { return; }
    
    CGFloat bottomHeight = CGRectGetHeight(_collectionViewBottomView.frame);
    
    _collectionViewBottomView.frame = CGRectMake(0, self.contentSize.height, CGRectGetWidth(self.frame), bottomHeight);
    
    UIEdgeInsets tempInset = self.contentInset;
    tempInset.bottom = bottomHeight;
    self.contentInset = tempInset;
}

- (void)layoutLeftView {
    
    if (_collectionViewLeftView == nil) { return; }
    
    CGFloat leftWidth = CGRectGetWidth(_collectionViewLeftView.frame);
    
    _collectionViewLeftView.frame = CGRectMake(-leftWidth, 0, leftWidth, CGRectGetHeight(self.frame));
    
    UIEdgeInsets tempInset = self.contentInset;
    tempInset.left = leftWidth;
    self.contentInset = tempInset;
}

- (void)layoutRightView {
    
    if (_collectionViewRightView == nil) { return; }
    
    CGFloat rightWidth = CGRectGetWidth(_collectionViewRightView.frame);
    
    _collectionViewRightView.frame = CGRectMake(self.contentSize.width, 0, rightWidth, CGRectGetHeight(self.frame));
    
    UIEdgeInsets tempInset = self.contentInset;
    tempInset.right = rightWidth;
    self.contentInset = tempInset;
}

// TODO: UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return _shouldMultipleGestureRecognize;
}

@end
