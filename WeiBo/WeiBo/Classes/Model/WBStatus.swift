//
//  WBStatus.swift
//  WeiBo
//
//  Created by godyu on 2018/4/28.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class WBStatus: NSObject {
    
    ///微博ID: 下拉刷新的since_id
    var id : Int64 = 0
    
    ///微博ID ：上拉刷新的时候用
    var mid : Int64 = 0
    
    ///微博正文信息
    var text : String?
    
    ///微博来源
    var source : String? {
        didSet {
            source = "来自" + (source?.ccy_href()?.text ?? "")
        }
    }
    
    ///微博用户信息
    var user : WBUser?
    
    ///转发数
    var reposts_count : Int = 0
    
    ///评论数
    var comments_count : Int = 0
    
    ///赞数
    var attitudes_count : Int = 0
    
    ///图片
    var pic_urls : [[String : String]]?
    ///大图片
    var pic_largeUrls : [[String : String]]?
    
    ///创建日期
    var created_at : String? {
        didSet {
            createDate = Date.ccy_sinaDate(string: created_at ?? "")
        }
    }
    
    ///具体创建微博的时间
    var createDate : Date?
    
    ///转发微博模型
    var retweeted_status : WBStatus?
    
    required override init() {
        
    }
    
    override var description: String {
        return yy_modelDescription()
    }
    

}

extension WBStatus : HandyJSON {
}
