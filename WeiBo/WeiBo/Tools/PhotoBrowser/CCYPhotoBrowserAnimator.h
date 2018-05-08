//
//  CCYPhotoBrowserAnimator.h
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CCYPhotoBrowserPhotos;

/*
 * 照片浏览动画器
 */
@interface CCYPhotoBrowserAnimator : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

/**
 实例化动画器

 @param photos 浏览照片模型
 @return 照片浏览动画器
 */
+ (instancetype)animatorWithPhotos:(CCYPhotoBrowserPhotos *_Nonnull)photos;

/** 解析转场当前显示的图像视图 */
@property (nonatomic, strong)UIImageView *fromImageView;


@end
