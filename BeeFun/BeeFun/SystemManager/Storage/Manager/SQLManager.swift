//
//  SQLManager.swift
//  BeeFun
//
//  Created by WengHengcong on 19/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import SQLite

enum SQLiteError: Error {
    case connecttion
}

enum SQLiteAction: Int {
    case insert
    case update
    case delete
    case query
}

struct SQLManager {
    
    static let githubDatabaseName = "github.sqlite3"
    
    static func createAllTables() {
        //建表
        SQLStars.crateStarReposTable()
        SQLTags.crateStarTagsTable()
    }
    
    static var githubDb: Connection = {
        let sqlBridge = JSSQLiteSwiftBridge()
        sqlBridge.dbName = githubDatabaseName
        return sqlBridge.connection()
    }()

    static func checkDBValid() {
        if let url = BFPathManager.shared.localDocumentURL(fileName: SQLManager.githubDatabaseName), !FileManager.default.fileExists(atPath: url.path) {
            //无本地数据库，开始下载创建本地数据库
            _ = SQLManager.githubDb
            SQLManager.createAllTables()
        } else if !self.checkTableExist(SQLStars.starTableName) || !self.checkTableExist(SQLTags.starTagsName) {
            //有本地数据库，则重新下载最新数据
            SQLStars.crateStarReposTable()
            SQLManager.beginDownloadDataToDB()
        }
    }
    
    static func checkTableExist(_ tableName: String) -> Bool {
        return SQLManager.githubDb.tableExists(tableName: tableName)
    }
    
    static func beginDownloadDataToDB() {
        /// 首次启动同步网络数据
    }
}
