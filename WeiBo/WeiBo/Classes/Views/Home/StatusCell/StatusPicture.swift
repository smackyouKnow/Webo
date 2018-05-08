//
//  StatusPicture.swift
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class StatusPicture: UIView {

    @IBOutlet weak var pictureViewHeight : NSLayoutConstraint!
    
    var statusViewModel : WBStatusViewModel? {
        didSet {
            calcViewSize()
        }
    }
    
    //便利urls数组，顺序设置图像
    var urls : [[String : String]]? {
        didSet {
            
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for urlDict in urls ?? [] {
                
                //获取对应的imageView
                let imageView = subviews[index] as! UIImageView
                
                //处理4张图片，正方形排列
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                let url = URL.init(string: urlDict["thumbnail_pic"]!)
//                imageView.sd_setImage(with: url, completed: nil)
                imageView.sd_setImage(with: url, placeholderImage: nil, options: [], progress: nil, completed: nil)
                
                //判断是否是gif，根据扩展名
                imageView.subviews[0].isHidden = ((urlDict["thumbnail_pic"]! as NSString).pathExtension.lowercased() != "gif")
                
                imageView.isHidden = false
                
                index += 1
            }
        }
    }
    
    ///计算
    private func calcViewSize() {
        
        if statusViewModel?.picURLs?.count == 1 {
            let v = subviews[0]
            
            let viewSize = statusViewModel?.pictureViewSize ?? CGSize()
            v.frame = CGRect.init(x: 0, y: WBStatusPictureOutterMargin, width: viewSize.width, height: viewSize.height)
        } else {
            let v = subviews[0]
            v.frame = CGRect.init(x: 0, y: WBStatusPictureOutterMargin, width: WBStausPictureItemWidth, height: WBStausPictureItemWidth)
        }
        
        pictureViewHeight.constant = self.statusViewModel?.pictureViewSize.height ?? 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

}

extension StatusPicture {
    private func setupUI() {
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        //循环创建9个imageView

        for i in 0..<9 {
            let imageView = UIImageView.init()
            
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let row = CGFloat(i / 3)
            let col = CGFloat(i % 3)
            
            let x = col * (WBStatusPictureIntterMargin + WBStausPictureItemWidth)
            let y = row * (WBStausPictureItemWidth + WBStatusPictureIntterMargin) + WBStatusPictureOutterMargin
            
            imageView.frame = CGRect.init(x: x, y: y, width: WBStausPictureItemWidth, height: WBStausPictureItemWidth)
            addSubview(imageView)
            
            //添加手势
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
            imageView.addGestureRecognizer(tap)
            
            //添加gif视图
            addGifView(imageView: imageView)
        }
    }
    
    @objc func tapClick(sender : UIGestureRecognizer) {
        guard let imageView = sender.view,
            let picUrls = statusViewModel?.picURLs
        else {
            return
        }
        var selectedIndex = imageView.tag
        if picUrls.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }

        //把图片url替换成大图url
        var urls = [String]()
        for picDict in picUrls {
            guard let thumbnail_pic = picDict["thumbnail_pic"] else {
                continue
            }
            //替换大图
            let largePic = thumbnail_pic.replacingOccurrences(of: "wap360", with: "large")
            urls.append(largePic)
        }
        
        var imageViewList = [UIImageView]()
        
        for iv in subviews as! [UIImageView] {
            if !iv.isHidden {
                imageViewList.append(iv)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StatusCellBrowserPhotoNotification), object: nil, userInfo: [WBStatusCellBrowserPhotoUrlKey : urls, WBStatusCellBrowserPhotoSelectedIndexKey : selectedIndex, WBStatusCellBrowserPhotosKey : imageViewList])
        
    }
    
    private func addGifView(imageView : UIImageView) {
        let gifImageView = UIImageView.init(image: UIImage.init(named: "common-gif"))
        imageView.addSubview(gifImageView)
        
        gifImageView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.left.equalTo(imageView)
        }
    }
}
