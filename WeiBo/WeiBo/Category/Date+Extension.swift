//
//  Date+Extension.swift
//  WeiBo
//
//  Created by godyu on 2018/5/2.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

private let dateFormatter = DateFormatter()
private let calender = Calendar.current

extension Date {
    
    static func ccy_sinaDate(string : String) -> Date? {
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_US");
        
        return dateFormatter.date(from: string)
    }

    
    var ccy_dateDescription : String {
        if calender.isDateInToday(self) {
            let detal = -Int(self.timeIntervalSinceNow)
            if detal < 60 {
                return "刚刚"
            }
            
            if detal < 3600 {
                return "\(detal / 60)分钟前"
            }
            return "\(detal / 3600)小时前"
        }
        
        //其他天
        var fmt = " HH:mm"
        if calender.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let year = calender.component(.year, from: self)
            let thisYear = calender.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        dateFormatter.dateFormat = fmt
        return dateFormatter.string(from: self)
    }
}
