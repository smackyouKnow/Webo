//
//  EmotionCell.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

@objc protocol EmotionCellDelegate : NSObjectProtocol {
    func emotionCellDidSelectedEmotion(cell : EmotionCell, emtion: Emotion?)
}

class EmotionCell: UICollectionViewCell {
    
    ///弹出视图
    lazy var tipView : EmotionTipView = EmotionTipView()
    
    weak var delegate : EmotionCellDelegate?
    
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let w = newWindow else {
            return
        }
        
        w.addSubview(tipView)
        tipView.isHidden = true
    }
    
    //点击按钮
    @objc func selectedEmoticonButton(btn: UIButton) {
        let tag = btn.tag
        //假如点击的是删除按钮(第21个)，em为nil
        var em : Emotion?
        if tag < (emotions?.count)! {
            em = emotions?[tag]
        }
        
        delegate?.emotionCellDidSelectedEmotion(cell: self, emtion: em)
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
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
            
            contentView.addSubview(btn)
        }
        
        let removeBtn = contentView.subviews.last as! UIButton
        removeBtn.setImage(UIImage.init(named: "delete@3x"), for: .normal)
    
        //添加长按手势
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress))
        
        longGesture.minimumPressDuration = 0.1
        self.addGestureRecognizer(longGesture)
        

    }
    
    @objc func longPress(gesture: UIGestureRecognizer) {
        //获取触摸位置
        let location = gesture.location(in: self)
        
        //获取触摸位置对应的按钮
        guard let btn = buttonWithLocation(location: location) else {
            
            self.tipView.isHidden = true
            return
        }
        
        ///处理手势状态
        switch gesture.state {
        case .began, .changed:
            tipView.isHidden = false
            
            //左边转换 -> 将按钮参照cell的坐标系，转换到window中
            let center = self.convert(btn.center, to: window)
            tipView.center = center
            
            tipView.emotion = emotions?[btn.tag]
            
            
        case .ended:
            tipView.isHidden = true
            self.selectedEmoticonButton(btn: btn)
            
        case .cancelled:
            tipView.isHidden = true
            
        default:
            break
        }
        
    }
    
    private func buttonWithLocation(location: CGPoint) -> UIButton? {
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && btn.isHidden == false && btn != contentView.subviews.last {
                return btn
            }
        }
        return nil
    }
}
