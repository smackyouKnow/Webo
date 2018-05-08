//
//  CCYHomeStatusListViewModel.swift
//  WeiBo
//
//  Created by godyu on 2018/4/28.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import HandyJSON
import SDWebImage

///上拉刷新出现错误的最大次数,用于测试账号
private let maxPullupErrorTimes = 5

class CCYHomeStatusListViewModel {

    ///记录上拉加载次数
    private var pullupErrorTimes = 0
    
    lazy var statusList = [WBStatusViewModel]()
    
    //MARK: 加载微博数据
    /// 加载首页信息
    ///
    /// - Parameters:
    ///   - pullup: 是否是上拉刷新
    ///   - completion: 回调
    func loadStatus(pullup : Bool, completion:@escaping (_ isSuccess : Bool) ->()) {
        
        //0.判断是否是上拉刷新，同时检查刷新错误
        if pullup && pullupErrorTimes > maxPullupErrorTimes {
            
            completion(false)
            return
        }
        
        let sinceid = pullup ? 0 : (self.statusList.first?.status.id ?? 0)
        let maxid = pullup ? (self.statusList.last?.status.mid ?? 0) : 0
        
        //加载数据
        CCYNetworkManager.shared.statusList(since_id: sinceid, max_id: maxid) { (list, isSuccess) in
            
//            print(list)
            if !isSuccess {
                self.pullupErrorTimes += 1
                
                completion(false)
                return
            }
            
            //字典转模型 -> 视图模型，将视图模型加到数组
            var array = [WBStatusViewModel]()
            for dict in list ?? [] {
                guard let status = JSONDeserializer<WBStatus>.deserializeFrom(dict: dict),
                    let create_at = dict["created_at"] as? String,
                    let source = dict["source"] as? String
                else {
                    continue
                }
                status.created_at = create_at
                status.source = source
                
                array.append(WBStatusViewModel.init(model: status))
            }
            
            //视图模型创建完成
            
            //拼接数据
            if pullup {
                //上拉
                self.statusList = self.statusList + array
            } else {
                self.statusList = array
            }
            
            //判断上拉刷新的数量
            if array.count == 0 {
                self.pullupErrorTimes += 1
                completion(false)
            } else {
                self.cacheSingleImage(list: array, finish: completion)
            }
            
            completion(isSuccess)
        }
    }

    //MARK: 缓存单张图片
    func cacheSingleImage(list: [WBStatusViewModel], finish: @escaping (_ isSuccess: Bool) -> ()) {
        
        let group = DispatchGroup.init()
        
        var length = 0
        
        for viewModel in list {
            if viewModel.picURLs?.count != 1 {
                continue
            }
            
            guard let pic = viewModel.picURLs![0]["thumbnail_pic"] else {
                continue
            }
            
            let url = URL.init(string: pic)
            
            group.enter()
            
            SDWebImageManager.shared().imageDownloader.downloadImage(with: url, options: [], progress: nil) { (image, _, _, _) in
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    length += data.count
                    
                    viewModel.updateSingleImageSize(image: image)
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            finish(true)
        }
    }
}
