//
//  CCYPhotoProgressView.m
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoProgressView.h"

@implementation CCYPhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - setter & getter
- (void)setProgress:(float)progress {
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
    
}

- (UIColor *)trackTintColor {
    if (_trackTintColor == nil) {
        _trackTintColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return _trackTintColor;
}

- (UIColor *)progressTintColor {
    if (_progressTintColor == nil) {
        _progressTintColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    }
    return _progressTintColor;
}

- (UIColor *)borderTintColor {
    if (!_borderTintColor) {
        _borderTintColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    }
    return _borderTintColor;
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    
    if (rect.size.width == 0 || rect.size.height == 0) {
        return;
    }
    
    if (_progress >= 1.0) {
        return;
    }
    
    CGFloat radius = MIN(rect.size.width, rect.size.height) * 0.5;
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    
    //绘制外圈
    [self.borderTintColor setStroke];
    
    CGFloat lineWidth = 2.0;
    UIBezierPath * borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius - lineWidth / 2.0 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
   
    borderPath.lineWidth = lineWidth;
    
    [borderPath stroke];
    
    //绘制内圆
    [self.trackTintColor setFill];
    radius -= lineWidth-0.5;
    UIBezierPath * trackPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [trackPath fill];
    
    //绘制进度
    [self.progressTintColor setFill];
    
    CGFloat start = -M_PI_2;
    CGFloat end = start + self.progress * M_PI * 2;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    [progressPath addLineToPoint:center];
//    [progressPath closePath];
    [progressPath fill];
}


@end
