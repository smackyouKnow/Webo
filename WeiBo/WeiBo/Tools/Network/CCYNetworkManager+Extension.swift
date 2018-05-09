//
//  CCYNetworkManager+Extension.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import YYModel
import HandyJSON

extension CCYNetworkManager {
    
    //MARK: 请求首页列表数据
    func statusList(since_id : Int64 = 0, max_id : Int64, completion:@escaping (_ list : [[String : AnyObject]]?, _ isSuccess : Bool) -> ()) {
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params = ["since_id" : since_id, "max_id" : max_id];
        
        tokenRequest(method: .GET, URLString: urlString, parameters:  params as [String : AnyObject]?, name: nil, data: nil) { (json, isSuccess) in
            let result = json?["statuses"] as? [[String : AnyObject]]
            
            completion(result, isSuccess)
        }
    }
    
    //MARK: 请求accessToken
    func loadAccessToken(code : String, completion:@escaping (_ isSuccess : Bool) -> ()) {
        
        
        self.request(method: .POST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: ["client_id" : AppKey as AnyObject, "client_secret" : AppSecret as AnyObject, "grant_type" : "authorization_code" as AnyObject, "code" : code as AnyObject, "redirect_uri" : RedirectURL as AnyObject]) { (json, isSuccess) in
            
            guard let json = json as? [String : AnyObject],
                let access_token = json["access_token"] as? String,
                let uid = json["uid"] as? String,
                let expires_in = json["expires_in"] as? TimeInterval
                else {
                    completion(false)
                    return
            }
            
            
            self.userModel = JSONDeserializer<UserModel>.deserializeFrom(dict: json)!
            
            self.userModel.expires_in = expires_in
//            print(json)
//            let success = self.userModel.yy_modelSet(with: json)
//            self.userModel.access_token = access_token
//            self.userModel.uid = uid
//            self.userModel.expires_in = expires_in
            
            self.loadUserAccount(completion: completion)
        }
    }
    
    //MARK: 请求用户信息
    private func loadUserAccount(completion:@escaping (_ isSuccess : Bool) -> ()) {
        guard let uid = self.userModel.uid else {
            return
        }
        
        let parameter = ["access_token" : self.userModel.access_token, "uid" : uid]
        
        tokenRequest(method: .GET, URLString: "https://api.weibo.com/2/users/show.json", parameters: parameter as [String : AnyObject] , name: nil, data: nil) { (json, isSuccess) in
            //给模型赋值
            guard let json = json as? [String : AnyObject],
                let screen_name = json["screen_name"] as? String,
                let avatar_large = json["avatar_large"] as? String
                else {
                    completion(false)
                    return
            }
            self.userModel.screen_name = screen_name
            self.userModel.avatar_large = avatar_large
            //把信息存到本地
            self.userModel.saveUserAccount()
            
            completion(isSuccess)
        }
    }
}

//MARK: 发送微博
extension CCYNetworkManager {
    func postStatus(text : String, image: UIImage?, completion:@escaping ((_ result : [String : AnyObject]?, _ isSuccess : Bool) -> ())) {
        
        let url : String
        if image == nil {
            url = "https://api.weibo.com/2/statuses/update.json"
        } else {
            url = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        
        let params = ["status" : text]
        //如果图像不为空，需要设置name和data
        var name : String?
        var data : Data?
        
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        
        tokenRequest(method: .POST, URLString: url, parameters: params as [String : AnyObject], name: name, data: data) { (json, isSuccess) in
            completion(json as? [String : AnyObject], isSuccess)
        }
        
    }
}
