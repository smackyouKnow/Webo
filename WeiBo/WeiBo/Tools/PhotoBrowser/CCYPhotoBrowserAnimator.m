//
//  CCYPhotoBrowserAnimator.m
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import "CCYPhotoBrowserAnimator.h"
#import "CCYPhotoBrowserPhotos.h"
#import <YYWebImage/YYWebImage.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CCYPhotoBrowserAnimator{
    BOOL _isPresenting;
    CCYPhotoBrowserPhotos *_photos;
}

+ (instancetype)animatorWithPhotos:(CCYPhotoBrowserPhotos *)photos {
    return [[self alloc] initWithPhotos:photos];
}

- (instancetype)initWithPhotos:(CCYPhotoBrowserPhotos *)photos {
    if (self = [super init]) {
        _photos = photos;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresenting = NO;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _isPresenting ? [self presentTransition:transitionContext] : [self dismissTransition:transitionContext];
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //容器
    UIView *containerView = [transitionContext containerView];
    
    //那个移动的图片
    UIImageView *dummyIV = [self dummyImageView];
    //目的地图片
    UIImageView *parentIV = [self parentImageView];
    //设置开始frame
    dummyIV.frame = [containerView convertRect:parentIV.frame fromView:parentIV.superview];
    [containerView addSubview:dummyIV];
    
    //设置目标view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:toView];
    toView.alpha = 0.0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        dummyIV.frame = [self presentRectWithImageView:dummyIV];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [dummyIV removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }];
    
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)dismissContext {
    UIView *containerView = [dismissContext containerView];
    UIView *fromView = [dismissContext viewForKey:UITransitionContextFromViewKey];
    
    //获取做动画的图片
    UIImageView *dummyIV = [self dummyImageView];
    dummyIV.frame = [containerView convertRect:_fromImageView.frame fromView:_fromImageView.superview];
    dummyIV.alpha = fromView.alpha;
    [containerView addSubview:dummyIV];
    
    //清楚被dismiss的视图
    [fromView removeFromSuperview];
    
    //得出目标的位置
    UIImageView *parentIV = [self parentImageView];
    CGRect targetRect = [containerView convertRect:parentIV.frame fromView:parentIV.superview];
    
    [UIView animateWithDuration:[self transitionDuration:dismissContext] animations:^{
        dummyIV.frame = targetRect;
        dummyIV.alpha = 1.0;
    } completion:^(BOOL finished) {
        [dummyIV removeFromSuperview];
        [dismissContext completeTransition:YES];
    }];
}

//根据图像计算展现目标尺寸
- (CGRect)presentRectWithImageView:(UIImageView *)imageView {
    UIImage *image = imageView.image;
    
    if (image == nil) {
        return imageView.frame;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = screenSize;
    
    imageSize.height = image.size.height * imageSize.width / image.size.width;
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    if (imageSize.height < screenSize.height) {
        rect.origin.y = (screenSize.height - imageSize.height) * 0.5;
    }
    return rect;
}


//======获取做动画的图片=========

- (UIImageView *)dummyImageView {
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[self dummyImage]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (UIImage *)dummyImage {
    NSString *key = _photos.urls[_photos.selectedIndex];
    //先去缓存池找
    UIImage *image = [[YYWebImageManager sharedManager].cache getImageForKey:key];
//    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:key];

    //如果没有，再用刚刚列表的小图片
    if (image == nil) {
        image = _photos.parentImageViews[_photos.selectedIndex].image;
    }
    return image;
}

//父视图参考图像视图
- (UIImageView *)parentImageView {
    return _photos.parentImageViews[_photos.selectedIndex];
}

@end
