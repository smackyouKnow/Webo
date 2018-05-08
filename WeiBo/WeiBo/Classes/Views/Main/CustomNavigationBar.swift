//
//  CustomNavigationBar.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<subviews.count {
            let view = subviews[i]
            if i == subviews.count - 2 {
                var frame = view.frame
                frame.origin.y = self.frame.size.height - frame.size.height
                view.frame = frame;
            } else {
                var frame = view.frame
                frame.size.height = self.frame.size.height
                view.frame = frame;
            }
            
        }
    }

}
