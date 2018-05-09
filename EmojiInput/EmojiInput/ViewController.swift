//
//  ViewController.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let emotionInputView : EmotionInputView = EmotionInputView.show { (em) in
        print(em)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let tf = UITextField.init(frame: CGRect.init(x: 50, y: 100, width: 300, height: 30))
        tf.backgroundColor = UIColor.lightGray
        tf.placeholder = "你好打野"
        tf.addTarget(self, action: #selector(emotionKeyBoard), for: .editingDidBegin)
        tf.tag = 1
        view.addSubview(tf)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil);
    }
    
    @objc func emotionKeyBoard(textField : UITextField) {
        print("开始输入")
        emotionInputView.frame = CGRect.init(x: 0, y: 0, width: 320, height: 253)
        textField.inputView = (textField.inputView == nil) ? emotionInputView : nil
        textField.reloadInputViews()
        
    }
    
    @objc func keyboardDidShow(noti: NSNotification) {
        
        let frame = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

