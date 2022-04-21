//
//  ZSShadowView.m
//  Pods-ZSViewUtil-Objc_Example
//
//  Created by Josh on 2021/3/29.
//

#import "ZSShadowView.h"

@interface ZSShadowView ()

@property (nonatomic, strong) UIView *contentView;

@end


@implementation ZSShadowView

- (UIView *)contentView {
    
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.backgroundColor = UIColor.clearColor;
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setShadowFillColor:(UIColor *)shadowFillColor {
    
    _shadowFillColor = shadowFillColor;
    [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    
    _shadowColor = shadowColor;
    [self setNeedsDisplay];
}

- (void)setShadowBlur:(CGFloat)shadowblur {
    
    _shadowBlur = shadowblur;
    [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGPoint)shadowoffset {
    
    _shadowOffset = shadowoffset;
    [self setNeedsDisplay];
}

- (void)setShadowRadius:(CGFloat)shadowradius {
    
    _shadowRadius = shadowradius;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect pathRect = CGRectInset(self.bounds, self.shadowBlur, self.shadowBlur);
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:self.shadowRadius];
    
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeMake(self.shadowOffset.x, self.shadowOffset.y), self.shadowBlur, self.shadowColor.CGColor);
    
    [self.shadowFillColor setFill];
    [rectanglePath fill];
    
    CGContextRestoreGState(context);
    
    self.contentView.frame = pathRect;
    self.contentView.layer.cornerRadius = self.shadowRadius;
}

@end
