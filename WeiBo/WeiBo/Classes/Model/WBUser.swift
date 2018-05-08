//
//  WBUser.swift
//  WeiBo
//
//  Created by godyu on 2018/5/2.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class WBUser: NSObject {

    ///用户昵称
    var screen_name : String?
    
    ///用户头像地址
    var profile_image_url : String?
    
    ///用户id
    var id : Int64 = 0
    
    ///会员等级
    var mbrank : Int = 0
    
    ///认证类型
    var verified_type : Int64 = 0

    required override init() {
        
    }
}

extension WBUser : HandyJSON {
    
}
