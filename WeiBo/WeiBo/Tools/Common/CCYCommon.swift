//
//  CCYCommon.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

//MARK: 通知相关
///通知成功通知
let CCYWeiBoShouldLoginSuccessNofication = "CCYWeiBoShouldLoginSuccessNofication"
///需要授权的通知
let CCYWeiBoShouldLoginNotfication = "CCYWeiBoShouldLoginNotfication"
///点击首页cell的图片通知
let StatusCellBrowserPhotoNotification = "StatusCellBrowserPhotoNotification"
///首页点击cell通知的图片的url数组
let WBStatusCellBrowserPhotoUrlKey = "WBStatusCellBrowserPhotoUrlKey"
///首页点击cell图片的index
let WBStatusCellBrowserPhotoSelectedIndexKey = "WBStatusCellBrowserPhotoSelectedIndexKey"
///首页点击cell图片的的图片数组
let WBStatusCellBrowserPhotosKey = "WBStatusCellBrowserPhotosKey"

//MARK: 应用程序信息
let AppKey = "984498496"
let AppSecret = "577872ac41e8ce31b4af98d194fd7927"
//回调地址
let RedirectURL = "http://www.baidu.com"


//MARK: 常量相关

///配图视图外部的间距
let WBStatusPictureOutterMargin = CGFloat(12)

///配图视图内部间距
let WBStatusPictureIntterMargin = CGFloat(3)

///配图视图的宽度
let WBStatusPictureViewWidth = UIScreen.screen_width() - 2 * WBStatusPictureOutterMargin
///cell图片的默认的宽度
let WBStausPictureItemWidth = (WBStatusPictureViewWidth - 2 * WBStatusPictureIntterMargin) / 3
