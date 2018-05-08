//
//  VistorView.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import SnapKit

class VistorView: UIView {

    ///数据源
    var vistorInfo : [String : AnyObject]?{
        didSet {
            
            guard let vistorInfo = vistorInfo else {
                return
            }
            
            guard let imageName = vistorInfo["imageName"] as? String,
                let text = vistorInfo["message"] as? String
            else {
                return
            }
            self.iconView.image = UIImage.init(named: imageName)
            self.topLabel.text = text
        }
    }
    
    
    //图标
    private lazy var iconView = UIImageView.init(image: UIImage.init(named: "place"))
    
    //提示标签
    private lazy var topLabel : UILabel = UILabel.createLabel(withText: "呵呵哒", fontSize: 16, textColor: UIColor.darkGray)
    
    //注册按钮
    var registerButton : UIButton = UIButton.createButton(withText: "注册", fontSize: 16, normalTextColor: UIColor.orange, highlightedColor: UIColor.black)
    
    //登陆按钮
    var loginButton : UIButton = UIButton.createButton(withText: "登陆", fontSize: 16, normalTextColor: UIColor.darkGray, highlightedColor: UIColor.black)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VistorView {
    func setupUI() {
        self.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        
        addSubview(iconView)
        addSubview(topLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //布局
        //icon
        self.iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-80)
            make.width.equalTo(self).multipliedBy(0.33)
            make.height.equalTo(self.snp.width).multipliedBy(0.33)
        }
        
        //topLabel
        topLabel.numberOfLines = 0
        self.topLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.iconView.snp.bottom).offset(20)
            make.width.equalTo(236)
        }
        
        
        //registerButton
        self.registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.topLabel.snp.left)
            make.top.equalTo(self.topLabel.snp.bottom).offset(15)
            make.width.equalTo(100)
        }
        
        //loginButton
        self.loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.topLabel.snp.right)
            make.top.equalTo(self.registerButton.snp.top)
            make.width.equalTo(100)
        }
        
    }
}
