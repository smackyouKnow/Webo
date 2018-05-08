//
//  CCYNetworkManager.swift
//  WeiBo
//
//  Created by godyu on 2018/4/27.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod {
    case GET
    case POST
}

class CCYNetworkManager: AFHTTPSessionManager {
    
    ///用户模型
    var userModel = UserModel()
    
    ///用户登录标记
    var isLogin : Bool {
       
        return userModel.access_token != nil
    }

    //单例
    static let shared : CCYNetworkManager = {
       let instance = CCYNetworkManager()
        
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    
    //MARK: 携带access_token的请求方法
    func tokenRequest(method : HTTPMethod = .GET, URLString : String, parameters : [String : AnyObject]?, completion : @escaping (_ json : AnyObject?, _ isSuccess : Bool) -> ()) {
        
        //1.判断access_token是否存在
        guard let access_token = userModel.access_token else {
            
            //FIXME: 发送通知，登录授权
            NotificationCenter.default.post(name: Notification.Name(rawValue: CCYWeiBoShouldLoginNotfication), object: nil)
            completion(nil, false)
            
            return
        }
        
        //2.判断字典是否为空
        var params = parameters
        if params == nil {
            //实例化字典
            params = [String : AnyObject]()
        }
        
        //2.1设置参数token
        params!["access_token"] = access_token as AnyObject
        
        request(method: method, URLString: URLString, parameters: params, completion: completion)
    }
    
    //MARK: 网络最底层的方法
    func request(method : HTTPMethod = .GET, URLString : String, parameters : [String : AnyObject]?, completion: @escaping (_ json : AnyObject?, _ isSuccess : Bool) -> ()) {
        
        let success = {(task : URLSessionDataTask, json : Any?) -> () in
                completion(json as AnyObject?, true)
        }
        
        let failure = {(tasks : URLSessionDataTask?, error : Error) -> () in
                completion(nil, false)
        }
        
        if method == .GET {
            self.get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            self.post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
    
}
