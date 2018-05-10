//
//  SqliteManager.swift
//  WeiBo
//
//  Created by godyu on 2018/5/9.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit
import FMDB

//一周
private let maxDBClearTime : TimeInterval = -5 * 24 * 3600

class SqliteManager: NSObject {

    static var shared = SqliteManager()
    
    var queue : FMDatabaseQueue!
    
    override init() {
        
        super.init()
        let dbPath = "status.sqlite"
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent(dbPath)
        
        queue = FMDatabaseQueue.init(path: path)
        
        createTable()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(clearDB), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func clearDB() {
        let dateString = Date.cy_dateString(detle: maxDBClearTime)
        
        let sql = "delete from T_status where createTime < ?;"
        
        //执行sql
        queue.inDatabase { (db) in
            if db.executeUpdate(sql, withArgumentsIn: [dateString]) == true {
                print("删除了\(db.changes)条数据")
            }
        }
    }
    
    
    
    private func createTable() {
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let dbString = try? String.init(contentsOfFile: path)
        else {
            return
        }
        
        queue.inDatabase { (db) in
            if db.executeStatements(dbString) == true {
                print("创建/打开表成功")
            }
        }
    }
}

//MARK: 微博数据操作
extension SqliteManager {
    
    func loadStatus(userId : String, since_id : Int64 = 0, max_id : Int64 = 0) -> [[String : AnyObject]] {
        
        //准备sql
        var sql = "select statusId, userId, status from T_status \n"
        
        sql += "where userId = \(userId) \n"
        
        if since_id > 0 {
            sql += "and statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "and statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId Desc LIMIT 20;"
        
        //执行sql
        let array = execRecordSet(sql: sql)
        
        //遍历数组，将数组中的status反序列化 -> 字典
        var result = [[String : AnyObject]]()
        
        for dict in array {
            guard let jsonData = dict["status"] as? Data,
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : AnyObject] else {
                    continue
            }
            result.append(json ?? [:])
        }
        return result
    }
    
    private func execRecordSet(sql : String) -> [[String : AnyObject]] {
       
        var rs = [[String : AnyObject]]()
        
        queue.inDatabase { (db) in
            guard let result = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            //遍历
            while result.next() {
                let colCount = result.columnCount
                
                //遍历所有列
                for col in 0..<colCount {
                    guard let name = result.columnName(for: col),
                        let value = result.object(forColumn: name) else {
                            continue
                    }
                    rs.append([name : value as AnyObject])
                }
            }
        }
        return rs
    }
}

//MARK: 微博数据库操作
extension SqliteManager {
    func updateStatus(userId: String, array: [[String : AnyObject]]) {
        
        let sql = "insert or replace into T_status(statusId, userId, status) values (?, ?, ?);"
        
        //执行sql
        queue.inTransaction { (db, rollback) in
            for dict in array {
                guard let statusId = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                //执行sql
                if db.executeUpdate(sql, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    print("插入失败")
                    
                    //回滚
                    rollback.pointee = true
                    
                    break
                }
            }
        }
    }
}
