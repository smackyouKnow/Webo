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
    
    ///最近使用表情
    func recentEmotion(em : Emotion) {
        em.times += 1
        
        //之前没有这个em，添加进去
        if !packages[0]!.emotions.contains(em) {
            packages[0]?.emotions.append(em)
        }
        
        //按照times排序
        packages[0]!.emotions.sort { (em1, em2) -> Bool in
            return (em1?.times)! > (em2?.times)!
        }
        
        //不能超过20
        if packages[0]!.emotions.count > 20 {
            packages[0]!.emotions.removeSubrange(20..<packages[0]!.emotions.count)
        }
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
