//
//  CCYPhotoBrowserPhotos.h
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 * 浏览照片模型
 */
@interface CCYPhotoBrowserPhotos : NSObject

/** 选中照片索引 */
@property (nonatomic, assign)NSInteger selectedIndex;

/** 照片url字符串数组 */
@property (nonatomic, strong)NSArray<NSString *> *urls;

/** 俯视图图像视图数组, 便于交互专场 */
@property (nonatomic, strong)NSArray<UIImageView *> *parentImageViews;


@end
