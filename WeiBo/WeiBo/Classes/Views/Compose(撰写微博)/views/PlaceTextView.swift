//
//  PlaceTextView.swift
//  WeiBo
//
//  Created by godyu on 2018/5/9.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class PlaceTextView: UITextView {

    lazy var placeholderLabel : UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.placeholderLabel.isHidden = self.hasText
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange() {
        self.placeholderLabel.isHidden = self.hasText
    }
    
}

extension PlaceTextView {
    private func setupUI() {
        placeholderLabel.text = "分享新鲜事...."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.darkGray
        placeholderLabel.frame = CGRect.init(x: 5, y: 8, width: self.frame.size.width, height: self.frame.size.height)
        placeholderLabel.sizeToFit()
        
        addSubview(placeholderLabel)
        
    }
}

extension PlaceTextView {
    func insertEmotion(em : Emotion?) {
        
        //如果em为空表示点击了删除键
        guard let em = em else {
            
            //删除文本
            deleteBackward()
            
            return
        }
        
        //判断是emoji还是表情图
        
        //如果是emoji直接插入
        if let emoji = em.emoji, let textRange = selectedTextRange {
            self.replace(textRange, withText: emoji)
            return
        }
        
        //到此，都是图片表情，获取属性文本(富文本)
        //所有的排版系统中，几乎都有一个共同的特点，插入的字符的显示，跟随前一个字符的属性，但是本身没有属性
        let imageText = em.imageText(font: self.font!)
        
        //1.取得当前现有的文本
        let attriStrM = NSMutableAttributedString.init(attributedString: self.attributedText)
        
        //2.替换
        attriStrM.replaceCharacters(in: self.selectedRange, with: imageText)
        
        //3.重置设置属性文本
        //记录光标位置
        let range = selectedRange
        self.attributedText = attriStrM
        
        //恢复光标位置
        selectedRange = NSRange.init(location: range.location + 1, length: 0)
        
        delegate?.textViewDidChange?(self)
        
        textDidChange()
    
    }
}

//MARK: 获取现在上面的所有文字(图片转换成文字)
extension PlaceTextView {
    var emotion : String {
        guard let attrStr = self.attributedText else {
            return ""
        }
        
        var result = String()
        
        //遍历富文本
        attrStr.enumerateAttributes(in: NSRange.init(location: 0, length: attrStr.length), options: []) { (dict, range, _) in
            
            //发现字典包含NSAttachment
            if let attachment = dict[NSAttributedStringKey.attachment] as? EmotionAttachment {
                //图片转换成文字
                result += attachment.chs ?? ""
                
            } else {
                let subStr = (attrStr.string as NSString).substring(with: range)
                result += subStr
            }
        }
        
        return result
    }
}
