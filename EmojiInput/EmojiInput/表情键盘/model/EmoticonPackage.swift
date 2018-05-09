//
//  EmoticonPackage.swift
//  EmojiInput
//
//  Created by godyu on 2018/5/8.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON

class EmoticonPackage: NSObject {
    
    ///每个包的数组
    lazy var emotions = [Emotion?]()

    ///包名字
    var name : String?
    
    ///包所在文件夹名称
    var id : String? {
        didSet {
            guard let id = id,
            let path = Bundle.main.path(forResource: "EmojiKeyBoard.bundle", ofType: nil),
            let bundle = Bundle.init(path: path),
            let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: id),
            let dict = NSDictionary.init(contentsOfFile: infoPath),
            let array = dict["emojis"] as? [[String : String]],
            let models = JSONDeserializer<Emotion>.deserializeModelArrayFrom(array: array)
            
            else {
                return
            }
            
            for (index, model) in models.enumerated() {
                
                guard let model = model
                else {
                    continue
                }
                model.code = array[index]["code"]
                model.directory = id
            }
            
            self.emotions += models
        }
    }
    
    ///总共几个cell
    var numberOfCells : Int {
        return (emotions.count - 1) / 20 + 1
    }
    
    //MARK: 每个cell对应的模型数据
    func emotion(page : Int) -> [Emotion] {
        //每页数据
        let count = 20
        let location = page * count
        var length = count
        
        //是否越界
        if location + length > emotions.count {
           length = emotions.count - location
        }
        
        let range = NSRange.init(location: location, length: length)
        
        let array = (emotions as NSArray).subarray(with: range)
        
        return array as! [Emotion]
    }
    
    
    override required init() {
    }
}

extension EmoticonPackage : HandyJSON {
    
}
