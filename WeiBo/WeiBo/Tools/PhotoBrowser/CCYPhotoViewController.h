//
//  CCYPhotoViewController.h
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 单张图片查看控制器
 */
@interface CCYPhotoViewController : UIViewController

+ (instancetype)viewWithURLString:(NSString *)urlString photoIndex:(NSInteger)photoIndex placeholder:(UIImage *)placeholder;

@property (nonatomic, assign)NSInteger photoIndex;

@property (nonatomic, readonly)UIScrollView *scrollView;
@property (nonatomic, readonly)UIImageView *imageView;

@end
