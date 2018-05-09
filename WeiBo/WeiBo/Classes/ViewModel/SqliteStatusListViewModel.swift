//
//  SqliteStatusListViewModel.swift
//  WeiBo
//
//  Created by godyu on 2018/5/9.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

class SqliteStatusListViewModel: NSObject {

    class func loadStatus(since_id : Int64 = 0, max_id : Int64 = 0, completion: @escaping ((_ list : [[String : AnyObject]]?, _ isSuccess : Bool) -> ())) {
    
        //用户id
        guard let userId = CCYNetworkManager.shared.userModel.uid else {
            return
        }
        
        let array = SqliteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        if array.count > 0 {
            completion(array, true)
            
            return
        }
        
        CCYNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            if !isSuccess {
                completion(nil, false)
            }
            
            guard let list = list else {
                completion(nil, false)
                return
            }
            
            SqliteManager.shared.updateStatus(userId: userId, array: list)
            
            completion(list, true)
            
        }
    }
    
}
