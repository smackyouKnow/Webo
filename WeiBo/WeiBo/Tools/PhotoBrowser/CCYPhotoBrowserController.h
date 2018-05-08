//
//  CCYPhotoBrowserController.h
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 照片浏览器
 */
@interface CCYPhotoBrowserController : UIViewController

/**
 实例化照片浏览器

 @param selectedIndex 选中照片索引
 @param urls url数组
 @param parentImageViews 父视图的图像视图数组， 作为转场动画参照
 @return 实例化对象
 */
+ (nonnull instancetype)photoBrowserWithSelectedIndex:(NSInteger)selectedIndex
                                         urls:(NSArray <NSString *> *)urls
                             parentImageViews:(NSArray <UIImageView *> *)parentImageViews;

@end
