//
//  CCYWelComeView.swift
//  WeiBo
//
//  Created by godyu on 2018/4/28.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import SDWebImage

class CCYWelComeView: UIView {
    
    let iconView : UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "welcome"))
        
        return imageView
    }()
    
    var nameLabel : UILabel = {
       
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = CCYNetworkManager.shared.userModel.screen_name
        label.alpha = 0
        return label
    }()

    var headIconView : UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "头像"))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.centerX.equalTo(self)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(iconView.snp.top).offset(-150)
            
        }
    
        addSubview(headIconView)
        
        if (CCYNetworkManager.shared.userModel.avatar_large != nil) {
            headIconView.sd_setImage(with: URL.init(string: CCYNetworkManager.shared.userModel.avatar_large!), completed: nil)
        }
        
        
        headIconView.contentMode = .scaleAspectFill
        headIconView.layer.cornerRadius = 35
        headIconView.layer.masksToBounds = true
        headIconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(nameLabel.snp.top).offset(-15)
            make.width.equalTo(70)
            make.height.equalTo(70)

        }
    }
    
    private func showAnimation() {

        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.headIconView.snp.removeConstraints()
            self.headIconView.snp.updateConstraints { (make) in
                make.centerY.equalTo(self).offset(-100)
                make.centerX.equalTo(self)
                make.width.equalTo(70)
                make.height.equalTo(70)
            }
            
            self.nameLabel.snp.removeConstraints()
            self.nameLabel.snp.updateConstraints({ (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(self.headIconView.snp.bottom).offset(10)
            })
            
            self.layoutIfNeeded()
        }) { (completion) in
            UIView.animate(withDuration: 1.0, animations: {
                self.nameLabel.alpha = 1
            }, completion: { (completion) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.removeFromSuperview()
                })
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showAnimation()
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
