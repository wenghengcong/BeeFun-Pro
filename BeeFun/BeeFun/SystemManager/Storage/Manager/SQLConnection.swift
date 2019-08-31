//
//  SQLConnection.swift
//  BeeFunMac
//
//  Created by WengHengcong on 2017/12/28.
//  Copyright © 2017年 LuCi. All rights reserved.
//

import SQLite

extension Connection {
    
    public func exists(column: String, in table: String) throws -> Bool {
        let stmt = try prepare("PRAGMA table_info(\(table))")
        
        let columnNames = stmt.makeIterator().map { (row) -> String in
            return row[1] as? String ?? ""
        }
        
        return columnNames.contains(where: { dbColumn -> Bool in
            return dbColumn.caseInsensitiveCompare(column) == ComparisonResult.orderedSame
        })
    }
    
    func tableExists(tableName: String) -> Bool {
        var exist = false
        do {
            exist = try SQLManager.githubDb.scalar(
                "SELECT EXISTS (SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?)",
                tableName
                ) as! Int64 > 0
        } catch {
            
        }
        return exist
    }
}
