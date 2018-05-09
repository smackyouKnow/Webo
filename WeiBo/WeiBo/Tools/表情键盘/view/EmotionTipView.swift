//
//  EmotionTipView.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/9.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import pop

class EmotionTipView: UIImageView {
    
    ///之前选择的表情
    private var preEmotion : Emotion?
    
    var emotion : Emotion? {
        didSet {
            
            //如果手一直在上面滑动，会一直调用这里
            if emotion == preEmotion {
                return
            }
            //记录表情
            preEmotion = emotion
            
            tipButton.setTitle(emotion?.emoji, for: .normal)
            tipButton.setImage(emotion?.image, for: .normal)
            
            let anim = POPSpringAnimation.init(propertyNamed: kPOPLayerPositionY)
            anim?.fromValue = 15
            anim?.toValue = 0
            
            anim?.springBounciness = 20
            anim?.springSpeed = 20
            tipButton.layer.pop_add(anim, forKey: nil)
            
        }
    }

    init() {
        let image = UIImage.init(named: "icon_yi_hao")
        super.init(image: image)
        
        self.layer.anchorPoint = CGPoint.init(x: 0.55, y: 1.3)
        
        //添加按钮
        tipButton.layer.anchorPoint = CGPoint.init(x: 0.45, y: 0)
        tipButton.frame = CGRect.init(x: 0, y: 0, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        tipButton.setTitle("😄", for: .normal)
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tipButton = UIButton()

}
