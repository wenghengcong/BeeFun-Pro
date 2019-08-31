//
//  SQLTags.swift
//  BeeFun
//
//  Created by WengHengcong on 02/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import SQLite

class SQLTags {
    
    static var retryCount: Int = 0
    static let starTagsName = "star_tags"
    fileprivate static let starTagsTable = Table(starTagsName)
    
    // MARK: - 字段
    /// name为唯一字段，不可重复，区分大小写
    fileprivate static let nameId = Expression<String>("name")
    /// 该tag下对应多少个repos
    fileprivate static let count = Expression<Int?>("count")
    /// 该tag下对应的repos，集合中为reposid
    fileprivate static let star_repos = Expression<SQLite.Blob?>("repos")
    /// order
    fileprivate static let tag_order = Expression<Int?>("tag_order")
}

extension SQLTags {
    /// 创建Star Repos
    static func crateStarTagsTable() {
        if retryCount > 3 {
            return
        }
        do {
            try SQLManager.githubDb.run(starTagsTable.create(ifNotExists: true) { (t) in
                t.column(nameId, primaryKey: true)
                t.column(count)
                t.column(star_repos)
                t.column(tag_order)
            })
        } catch {
            retryCount += 1
            crateStarTagsTable()
            print(error)
        }
    }
}

// MARK: - 增/改
extension SQLTags {
    /// 插入一个repos对象
    static func insert(tag: ObjTag) {
        do {
            if check(name: tag.name!) {
                let filterRow = starTagsTable.filter(nameId == tag.name!)
                let rowid = try SQLManager.githubDb.run(filterRow.update([
                    count <- tag.count,
                    tag_order <- tag.sort,
//                    star_repos <- SQLHelper.SQLBlob(intarray: tag.repos)
                ]))
                    
                print("tag updated id: \(rowid)")
            } else {
                let rowid = try SQLManager.githubDb.run(starTagsTable.insert([
                    nameId <- tag.name!,
                    count <- tag.count,
                    tag_order <- tag.sort,
//                    star_repos <- SQLHelper.SQLBlob(intarray: tag.repos!)
                    ]))
                print("tag inserted id: \(rowid)")
            }
        } catch {
            print("tag insertion failed: \(error)")
        }
    }
    
    /// 重命名tag
    static func rename(oriTag: ObjTag, newTag: ObjTag) {
        do {
                try SQLManager.githubDb.transaction {
                    delete(tag: oriTag)
                    insert(tag: newTag)
                }
        } catch {
            
        }
    }
    
}

// MARK: - 检查tags是否存在
extension SQLTags {
    /// 检查该id是否已经存在
    static func check(name: String) -> Bool {
        let query = starTagsTable.where(name == nameId)
        let all = try? SQLManager.githubDb.prepare(query)
        if all != nil {
            for item in all! where (name == item[nameId]) {
                return true
            }
        }
        return false
    }
}

// MARK: - 查询
extension SQLTags {
    
    /// 根据顺序查找tags
    ///
    /// - Parameters:
    ///   - order: 顺序
    static func findAll(order: SQLOrder) -> [ObjTag]? {
        let query = starTagsTable.order((order == .asc ? tag_order.asc : tag_order.desc))
        var tagsArr: [ObjTag] = []
        do {
            let all = Array(try SQLManager.githubDb.prepare(query))
            for item in all {
                let tag = convertObjTags(item: item)
                tagsArr.append(tag)
            }
            return tagsArr
        } catch {
            print(error)
            return nil
        }

    }
    
    /// 查找全部tags
    static func findAll() -> [ObjTag]? {
        var tagsArr: [ObjTag] = []
        do {
            let all = Array(try SQLManager.githubDb.prepare(starTagsTable))
            for item in all {
                let tag = convertObjTags(item: item)
                tagsArr.append(tag)
            }
            return tagsArr
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 查找全部tags，并获取字符串
    static func findAllByString() -> [String] {
        var tags: [String] = []
        if let all = findAll() {
            for item in all {
                tags.append(item.name!)
            }
        }
        return tags
    }
    
    /// 根据id查找repos对象
    static func find(name: String) -> ObjTag {
        let query = starTagsTable.where(nameId == name)
        let all = try? SQLManager.githubDb.prepare(query)
        var obj: ObjTag = ObjTag()
        if all != nil {
            for item in all! {
                obj = convertObjTags(item: item)
            }
        }
        return obj
    }
    
    static func convertObjTags(item: Row) -> ObjTag {
        let tag = ObjTag()
        tag.name = item[nameId]
        tag.count = item[count]
        tag.sort = item[tag_order]
//        tag.repos = SQLHelper.intArray(blob: item[star_repos])
        return tag
    }

}

// MARK: - 删
extension SQLTags {
    
    static func delete(name: String) {
        let query = starTagsTable.filter(name == nameId)
        do {
            if try SQLManager.githubDb.run(query.delete()) > 0 {
                print("deleted tag id:\(name)")
            } else {
                print("not found tag id:\(name)")
            }
        } catch {
            print("delete tag failed: \(error)")
        }
    }
    
    static func delete(tag: ObjTag) {
        let query = starTagsTable.filter(tag.name! == nameId)
        do {
            if try SQLManager.githubDb.run(query.delete()) > 0 {
                print("deleted tag id:\(tag.name)")
            } else {
                print("not found tag id:\(tag.name)")
            }
        } catch {
            print("delete tag failed: \(error)")
        }
    }
}
