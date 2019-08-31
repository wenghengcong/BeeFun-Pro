//
//  JSSQLiteSwiftBridge.swift
//  BeeFun
//
//  Created by WengHengcong on 22/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import  SQLite

class JSSQLiteSwiftBridge: NSObject {
    
    /// 数据库名称
    var dbName: String?
    
    /// 数据库路径
    var dbPath: String?
    
    /// 连接数据库
    func connection() -> Connection {
        assert((dbName != nil) || (dbPath != nil))
        if dbName != nil {
            return connection(name: dbName!)
        } else if dbPath != nil {
            return connection(path: dbPath!)
        } else {
            dbName = "db.sqlite3"
            return connection(name: dbName!)
        }
    }
    
    func connection(name: String) -> Connection {
        assert(!name.isEmpty)
        let dbpath = JSFileManager.documentsUrl.appendingPathComponent(name).absoluteString
        return connection(path: dbpath)
    }
    
    func connection(path: String) -> Connection {
        assert(!path.isEmpty)
        let db = try! Connection(path)
        return db
    }
}
