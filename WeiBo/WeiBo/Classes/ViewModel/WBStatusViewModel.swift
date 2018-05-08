//
//  WBStatusViewModel.swift
//  WeiBo
//
//  Created by godyu on 2018/4/28.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import YYModel

class WBStatusViewModel: CustomStringConvertible {
    var description: String = ""
    
    ///会员图标
    var vipIcon : UIImage?
    var memberIcon : UIImage?
    
    ///转发文字
    var retWeetedStr : String?
    ///赞文字
    var likeStr : String?
    ///评论文字
    var commentStr : String?
    
    ///正文文字
    var textAttributed: NSAttributedString?
    
    ///转发文字
    var relayAttribute : NSAttributedString?
    
    ///缓存行高
    var rowHeight : CGFloat = 0
    
    var pictureViewSize = CGSize()
    
    ///图片数组，如果是转发微博，原创一定没有图片
    var picURLs : [[String : String]]? {
        
        let urls = status.retweeted_status?.pic_urls ?? status.pic_urls
        var urls1 = [[String : String]]()
        for dict in urls ?? [] {
            let urlString = dict["thumbnail_pic"] ?? ""
            let tempDict = ["thumbnail_pic" : urlString.replacingOccurrences(of: "thumbnail", with: "wap360")]
            urls1.append(tempDict)
        }
        return urls1
    }
    
    var status : WBStatus
    
    //MARK: 构造函数
    init(model : WBStatus) {
        
        self.status = model
        
        ///会员图标赋值
        if (model.user?.mbrank ?? 0) > 0 && (model.user?.mbrank ?? 0) < 7 {
            let imageName = "vip\(model.user?.mbrank)"
            memberIcon = UIImage.init(named: imageName)
        }
        ///认证图标赋值
        switch model.user?.verified_type {
        case 0:
            vipIcon = UIImage.init(named: "Profile_AddV_authen")
        case 2, 3, 5:
            vipIcon = UIImage.init(named: "Profile_AddV_authen")
        case 220:
            vipIcon = UIImage.init(named: "Profile_AddV_authen")
        default:
            vipIcon = UIImage.init(named: "Profile_AddV_authen")
            break
        }
        
        ///底部工具栏计数字符串
        retWeetedStr = bottomCountStr(count: model.reposts_count, defaultString: "转发")
        likeStr = bottomCountStr(count: model.attitudes_count, defaultString: "赞")
        commentStr = bottomCountStr(count: model.comments_count, defaultString: "评论")
        
        //正文
        if let text = model.text {
            textAttributed = NSAttributedString.init(string: text, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        }
        
        
        ///转发文字
        var relayText = "@" + (model.retweeted_status?.user?.screen_name ?? "")
        relayText = relayText + ":" + (model.retweeted_status?.text ?? "")
        relayAttribute = NSAttributedString.init(string: relayText, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        
        //计算图片视图的大小
        pictureViewSize = self.caclPictureSize(count: self.picURLs?.count)
//        print(pictureViewSize)
        
        //计算行高
        countRowHeight()
        
    }
    
    //MARK: 计算图片视图的大小
    private func caclPictureSize(count : Int?) -> CGSize {
        guard let count = count else {
            return CGSize()
        }
        
        if count == 0 {
            return CGSize()
        }
        
        //计算高度
        //计算行数
        let row = CGFloat((count - 1) / 3 + 1)
        
        let height = WBStatusPictureOutterMargin + (row - 1) * WBStatusPictureIntterMargin + row * WBStausPictureItemWidth
        return CGSize.init(width: WBStatusPictureViewWidth, height: height)
    }
    
    //MARK: 计算行高
    private func countRowHeight() {
        let margin : CGFloat = 12
        let iconHeight : CGFloat = 35
        let bottomViewHeight : CGFloat = 36
        let topLineHeight : CGFloat = 5
        
        var cellHeight : CGFloat = 0
        
        let viewSize = CGSize.init(width: UIScreen.screen_width() - 2 * margin, height: CGFloat(MAXFLOAT))
        
        if let text = self.textAttributed {
            
            cellHeight += text.boundingRect(with: viewSize, options: .usesLineFragmentOrigin, context: nil).size.height
            
        }
        
        if self.status.retweeted_status != nil {
            if let replayText = relayAttribute {
                cellHeight += replayText.boundingRect(with: viewSize, options: .usesLineFragmentOrigin, context: nil).size.height
                cellHeight += margin * 2

            }
        }

        cellHeight += margin * 3 + iconHeight + bottomViewHeight + topLineHeight
        
        cellHeight += self.pictureViewSize.height
        
        rowHeight = cellHeight
    }
    
    //MARK: 单张图片处理
    func updateSingleImageSize(image : UIImage) {
        var size = image.size
        
        //过大处理
        let maxWidth : CGFloat = 300
        let minWidth : CGFloat = 40
        
        if size.width > maxWidth {
            size.width = maxWidth
            //等比例
            size.height = image.size.height * size.width / image.size.width
        }
        
        //过窄处理
        if size.width < minWidth {
            size.width = minWidth
            
            //要特殊处理高度，否则高度太大
            size.height = image.size.height * size.width / image.size.width / 4
        }
        
        //过高图片处理
        if size.height > 200 {
            size.height = 200
        }
        pictureViewSize = size
        size.height += WBStatusPictureOutterMargin
        
        pictureViewSize = size
        
        //更新行高
        countRowHeight()
        
    }
}

//MARK: 底部工具栏文字方法
extension WBStatusViewModel {
    
    private func bottomCountStr(count : Int, defaultString : String) -> String {
        if count <= 0 {
            return defaultString
        }
        
        if count < 10000 {
            return count.description
        }
        
        return String.init(format: "%.02f万", Double(count) / 10000.00)
    }
}
