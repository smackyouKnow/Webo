//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by godyu on 2018/5/7.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: PlaceTextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBarBottom: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ComposeButton: UIButton!
    
    lazy var input : EmotionInputView = EmotionInputView.show { [weak self] (em) in
        self?.textView.insertEmotion(em: em)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        //注册键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    @objc func keyboardDidShow(noti : NSNotification) {
        let rect = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        print(rect)
        print(duration)
        self.toolBarBottom.constant = -(UIScreen.scrren_height() - rect.origin.y)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    //点击toolbar按钮响应
    @objc func emotionKeyBoard() {
        input.frame = CGRect.init(x: 0, y: 0, width: 320, height: 253)
        self.textView.inputView = self.textView.inputView == nil ? input : nil
        
        self.textView.reloadInputViews()
    }
    
    //发布
    @objc func composeClick() {
        
        //图片转换成字符
        let text = textView.emotion
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.dark)
        CCYNetworkManager.shared.postStatus(text: text, image: nil) { (json, isSuccess) in
         
            let message = isSuccess ? "发布成功" : "发布失败"
            SVProgressHUD.showInfo(withStatus: message)
            
        }
    }
}

extension WBComposeViewController {
    
    private func setupUI() {
        setupNavgationBar()
        
        setupToolBar()
        
        self.textView.delegate = self
    }
    
    private func setupNavgationBar() {
        self.navigationItem.titleView = self.titleLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: ComposeButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(text: "返回", image: "buttonbar_back", normalTextColor: UIColor.darkGray, highliedTextColor: UIColor.orange, target: self, selector: #selector(back))
        self.ComposeButton.isEnabled = false
        ComposeButton.addTarget(self, action: #selector(composeClick), for: .touchUpInside)
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setupToolBar() {
        let images = [["imageName" : "synchronization_baoshi"],
                      ["imageName" : "synchronization_energy"],
                      ["imageName" : "synchronization_equipment"],
                      ["imageName" : "synchronization_feiyong", "actionName" :      "emotionKeyBoard"],
                      ["imageName" : "synchronization_finish"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in images {
            let btn = UIButton.init(type: .system)
            
            guard let imageName = dict["imageName"]
            
            else {
                return
            }
            btn.setBackgroundImage(UIImage.init(named: imageName), for: .normal)
            btn.sizeToFit()
            
            if let actionName = dict["actionName"] {
                let selector = NSSelectorFromString(actionName)
                btn.addTarget(self, action: selector, for: .touchUpInside)
            }
            
            let item = UIBarButtonItem.init(customView: btn)
            items.append(item)
            items.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        self.toolBar.items = items
    }
}

extension WBComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.ComposeButton.isEnabled = textView.hasText
    }
}
