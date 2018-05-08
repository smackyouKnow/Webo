//
//  CCYPhotoProgressView.h
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 图像下载进度视图
 */
@interface CCYPhotoProgressView : UIView

/** 进度 */
@property (nonatomic, assign)float progress;

/** 进度颜色 */
@property (nonatomic, strong)UIColor *progressTintColor;

/** 底色 */
@property (nonatomic, strong)UIColor *trackTintColor;
/** 边框颜色 */
@property (nonatomic, strong)UIColor *borderTintColor;



@end
