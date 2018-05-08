//
//  WBStatusPicture.swift
//  WeiBo
//
//  Created by godyu on 2018/5/2.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class WBStatusPicture: NSObject {

    var thumbnail_pic : String? {
        didSet {
            //设置大图片
            largePic = thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "large")
            
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "wap360")
        }
    }
    
    ///大图片
    var largePic : String?
    
    required override init() {
        
    }
    
}

extension WBStatusPicture : HandyJSON {
    
}
