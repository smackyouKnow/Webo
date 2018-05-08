//
//  WBComposeView.swift
//  WeiBo
//
//  Created by godyu on 2018/5/7.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import pop

class WBComposeView: UIView {

    
    @IBOutlet weak var slogan: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var cancelBtnCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var closeBtnCenterX: NSLayoutConstraint!
    
    var completionBlock : ((_ className : String?) -> ())?
    
    let buttonInfo = [["imageName": "publish-text", "title" : "发文字", "clasName" : "WBComposeViewController"],
                      ["imageName": "publish-picture", "title" : "发图片"],
                      ["imageName": "publish-review", "title" : "点赞"],
                      ["imageName": "publish-offline", "title" : "下载"],
                      ["imageName": "publish-video", "title" : "发视频"],
                      ["imageName" : "fengche", "title" : "更多", "actionName" : "clickMore"],
                      ["imageName" : "publish-audio" , "title" : "发语音"],
                      ["imageName" : "publish-text", "title" : "长微博"],
                      ["imageName" : "publish-picture", "title" : "朋友圈"],
                      ["imageName" : "publish-review", "title" : "好友圈"]]
    
    class func composeView() -> WBComposeView {
        
        let nib = UINib.init(nibName: "WBComposeView", bundle: Bundle.main)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeView
        
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    func show(completionBlock:@escaping (_ className : String?) -> ()) {
        
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        self.completionBlock = completionBlock
        vc.view.addSubview(self)
        cancelBtn.alpha = 0
        
        setupUI()
        
        showButtons()
    }
}

//MARK: 按钮点击
extension WBComposeView {
    
    //点击更多
    @objc func clickMore() {
        scrollView.setContentOffset(CGPoint.init(x: scrollView.bounds.width, y: 0), animated: true)
        
        self.closeBtnCenterX.constant = UIScreen.screen_width() / 4
        self.cancelBtnCenterX.constant = -UIScreen.screen_width() / 4
        
        UIView.animate(withDuration: 0.25) {
            self.cancelBtn.alpha = 1
            self.layoutIfNeeded()
            
        }
    }
    
    //点击其他按钮
    @objc func clickBtn(selectedBtn : ComposeButton) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated(){
            
            let anim = POPSpringAnimation.init(propertyNamed: kPOPViewScaleXY)
            
            let scale = (selectedBtn == btn) ? 1.5 : 0.7
            anim?.fromValue = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
            anim?.toValue = NSValue.init(cgPoint: CGPoint.init(x: scale, y: scale))
            anim?.springBounciness = 10
            btn.pop_add(anim, forKey: nil)
            
            //改变透明度
            let alphaAnim = POPBasicAnimation.init(propertyNamed: kPOPViewAlpha)
            alphaAnim?.toValue = 0.2
            alphaAnim?.duration = 0.5
            selectedBtn.pop_add(alphaAnim, forKey: nil)
            
            if i == v.subviews.count - 1 {
                anim?.completionBlock = {(_, _) -> () in
                    self.removeFromSuperview()
                    self.completionBlock!(selectedBtn.className)
                    
                }
            }
        }
    }
    
    //关闭
    @IBAction func CloseClick(_ sender: UIButton) {
        hiddenButtons()
    }
    
    //返回
    @IBAction func CancelClick(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        
        self.closeBtnCenterX.constant = 0
        self.cancelBtnCenterX.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.cancelBtn.alpha = 0
            self.layoutIfNeeded()
        }
    }
}

//MARK: 布局相关
extension WBComposeView {
    private func setupUI() {
        
        //0.强行布局,不然还是xib得frame
        layoutIfNeeded()
        
        let rect = scrollView.frame;
        
        for i in 0..<2 {
            let v = UIView.init(frame: CGRect.init(x: CGFloat(i) * rect.size.width, y: 0, width: rect.size.width, height: rect.size.height));
            
            scrollView.addSubview(v)
            
            scrollView.bounces = false;
            //禁用滑动
            scrollView.isScrollEnabled = false
            
            addButtons(view: v, viewIndex: i)
        }
        
        scrollView.contentSize = CGSize.init(width: 2.0 * UIScreen.screen_width(), height: 0)
    }
    
    private func addButtons(view : UIView, viewIndex : Int) {
        //每页最多的按钮数量
        let buttonCount = 6
        //从第几个按钮开始
        let buttonIndex = viewIndex * buttonCount
        
        for index in buttonIndex..<(buttonIndex + buttonCount) {
            
            //数组越界
            if index >= self.buttonInfo.count{
                break
            }
            
            guard let imageName = self.buttonInfo[index]["imageName"],
                let title = self.buttonInfo[index]["title"]
            else {
                continue
            }
            
            let btn = ComposeButton.compoeseButton(imageName: imageName, text: title)
            
            view.addSubview(btn)
            
            //添加按钮方法
            if let actionName = self.buttonInfo[index]["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
            }
            
            btn.className = self.buttonInfo[index]["clasName"]
        }
        
        //计算frame
        let btnSize = CGSize.init(width: 100, height: 100)
        let margin = (view.frame.size.width - 3 * btnSize.width) / 4
        for (i, btn) in view.subviews.enumerated() {
            let row : CGFloat = CGFloat(i / 3)
            let col : CGFloat = CGFloat(i % 3)
            let y = margin + (margin + btnSize.height) * row
            let x = margin + (margin + btnSize.width) * col
            btn.frame = CGRect.init(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
    }
}


extension WBComposeView {
    
    
    private func showButtons() {
        let v = scrollView.subviews[0]
        for (i, btn) in v.subviews.enumerated() {
            //设置按钮初始值
            var beginFrame = btn.frame;
            let endFrame = beginFrame
            beginFrame.origin.y += 400
            btn.frame = beginFrame;
            
            let anim = POPSpringAnimation.init(propertyNamed: kPOPViewFrame)
            
            anim?.fromValue = beginFrame
            anim?.toValue = endFrame
            anim?.springBounciness = 1
            anim?.springSpeed = 1
            
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            btn.pop_add(anim, forKey: nil)
        }
    }
    
    private func hiddenButtons() {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        let v = scrollView.subviews[page]
        
        for (i, btn) in v.subviews.enumerated().reversed() {
           
            let anim = POPBasicAnimation.init(propertyNamed: kPOPLayerPositionY)
            
            anim?.fromValue = btn.center.y
            anim?.toValue = btn.center.y + 400
            anim?.duration = 1
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i) * 0.025
            
            btn.layer.pop_add(anim, forKey: nil)
            
            if i == 0 {
                anim?.completionBlock = {(_, _) -> () in

                    self.removeFromSuperview()
                }
            }
        }
    }
}
