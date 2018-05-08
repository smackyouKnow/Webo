//
//  UIScreen+Extension.m
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "UIScreen+Extension.h"

@implementation UIScreen (Extension)

+ (CGFloat)screen_width {
    return [UIScreen mainScreen].bounds.size.width;
}


+ (CGFloat)scrren_height {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
