//
//  UIButton+Extension.m
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (instancetype)createButtonWithText:(NSString *)text fontSize:(CGFloat)fontSize normalTextColor:(UIColor *)normalTextColor highlightedColor:(UIColor *)highlightedColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    return button;
}

@end
