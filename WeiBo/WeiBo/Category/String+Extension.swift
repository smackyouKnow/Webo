//
//  String+Extension.swift
//  WeiBo
//
//  Created by godyu on 2018/5/2.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

extension String {
    
    //从字符串中提取链接和文本
    func ccy_href() -> (link : String, text : String)? {
        let patten = "<a href=\"(.*?)\" .*?=\"(.*?)\">(.*?)</a>"
        
        //创建正则表达式
        guard let regx = try? NSRegularExpression.init(pattern: patten, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange.init(location: 0, length: self.characters.count))
            
            else {
            return nil
        }
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 3))
        
        return (link, text)
    }
    
}
