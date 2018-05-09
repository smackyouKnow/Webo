//
//  EmotionCell.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class EmotionCell: UICollectionViewCell {
    
    var emotions : [Emotion]? {
        didSet {
            for v in contentView.subviews {
                v.isHidden = true
            }
            
            //显示删除按钮
            contentView.subviews.last?.isHidden = false
            
            for (i, emotion) in (emotions ?? []).enumerated() {
                guard let btn = contentView.subviews[i] as? UIButton else {
                    return
                }
                btn.isHidden = false
                //设置新浪图片
                btn.setImage(emotion.image, for: .normal)
                
                //设置emoji字符
                btn.setTitle(emotion.emoji, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EmotionCell {
    private func setupUI() {
        
        let colCount = 7
        let rowCount = 3
        
        //左下间距
        let leftMargin : CGFloat = 8
        let bottomMargin : CGFloat = 16
        
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            
            let width = (bounds.size.width - leftMargin * 2) / CGFloat(colCount)
            let height = (bounds.size.height - bottomMargin * 2) / CGFloat(rowCount)
            
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: leftMargin + CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            
            contentView.addSubview(btn)
        }
        
        let removeBtn = contentView.subviews.last as! UIButton
        removeBtn.setImage(UIImage.init(named: "delete@3x"), for: .normal)
    }
}
