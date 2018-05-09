//
//  EmotionManager.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class EmotionManager: NSObject {

    
    static let shared = EmotionManager()
    
    lazy var packages = [EmoticonPackage?]()
    
    private override init() {
        super.init()
        loadPackages()
    }
    
}

//MARK: 加载表情表
extension EmotionManager {
    private func loadPackages() {
        
        guard let path = Bundle.main.path(forResource: "EmojiKeyBoard.bundle", ofType: nil),
            let bundle = Bundle.init(path: path),
            let plistPath = bundle.path(forResource: "emojiPackage.plist", ofType: nil),
            let dict = NSDictionary.init(contentsOfFile: plistPath),
            let array = dict["packages"] as? [[String : String]],
            let models = JSONDeserializer<EmoticonPackage>.deserializeModelArrayFrom(array: array)
        else {
            return
        }
        
        //为了执行set方法
        for (index, model) in models.enumerated() {
            if let model = model {
                model.id = array[index]["id"]
            }
        }
        self.packages += models
    }
}
