//
//  UserModel.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import YYModel
import HandyJSON

private let accountFile = "userAccount.json"

class UserModel: NSObject {


    
    var access_token : String?
    var expires_in : TimeInterval = 0 {
        didSet {
//            guard
//                let remind_in = remind_in,
//                let remind = Double.init(remind_in)
//                else {
//                    return
//                }
            let date = Date.init(timeIntervalSinceNow:expires_in)
            let formatter = DateFormatter.init()
            formatter.dateFormat = "yyyy-MM-dd hh-mm-ss"
            expireDate = formatter.string(from: date)
        }
    }
    
    ///过期的日期
    var expireDate : String?
    
    var uid : String?
    
    var screen_name : String?
    
    var avatar_large : String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override required init() {
        super.init()
        
        let userPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + accountFile
        
        guard let data = NSData.init(contentsOfFile: userPath),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers),
            let userDict = dict as? [String : AnyObject],
            let access_token = userDict["access_token"] as? String,
            let uid = userDict["uid"] as? String,
            let expires_in = userDict["expires_in"] as? TimeInterval,
            let expireDate = userDict["expireDate"] as? String,
            let screen_name = userDict["screen_name"] as? String,
            let avatar_large = userDict["avatar_large"] as? String
        else {
            return
        }
        self.access_token = access_token
        self.uid = uid
        self.expires_in = expires_in
        self.expireDate = expireDate
        self.screen_name = screen_name
        self.avatar_large = avatar_large
        
        //判断是否过期
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd hh-mm-ss"
        let date = formatter.date(from: self.expireDate!)
        if date?.compare(Date()) != .orderedDescending {
            
            //清空
            self.access_token = nil
            self.uid = nil
            //删除本地
            try? FileManager.default.removeItem(atPath: userPath)
            //发送通知，请求授权
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CCYWeiBoShouldLoginNotfication), object: nil)
        }
    }
    
    func saveUserAccount() {
        
        var dict = [String : AnyObject]()
        dict["access_token"] = self.access_token as AnyObject
        dict["uid"] = self.uid as AnyObject
        dict["expires_in"] = self.expires_in as AnyObject
        dict["expireDate"] = self.expireDate as AnyObject
        dict["screen_name"] = self.screen_name as AnyObject
        dict["avatar_large"] = self.avatar_large as AnyObject
        print(dict)
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options:[]) else {
            return
        }
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let userPath = documentPath + "/" + accountFile
        (data as NSData).write(toFile: userPath, atomically: true)
    }
    
}


extension UserModel : HandyJSON {}
