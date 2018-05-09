//
//  EmotionTipView.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/9.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class EmotionTipView: UIImageView {
    
    
    
    var emotion : Emotion? {
        didSet {
            tipButton.setTitle(emotion?.emoji, for: .normal)
            tipButton.setImage(emotion?.image, for: .normal)
            
//            tipButton.transform = CGAffineTransform.init(translationX: 0, y: 5)
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
//                self.tipButton.transform = CGAffineTransform.identity
//            }) { (finish) in
//                
//            }
        }
    }

    init() {
        let image = UIImage.init(named: "icon_yi_hao")
        super.init(image: image)
        
        self.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1.3)
        
        //添加按钮
        tipButton.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
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
