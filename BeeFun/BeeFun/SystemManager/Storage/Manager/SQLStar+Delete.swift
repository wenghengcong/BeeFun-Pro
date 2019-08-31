//
//  SQLStar+Delete.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/2/1.
//  Copyright © 2018年 LuCi. All rights reserved.
//
import SQLite

extension SQLStars {
    
    // MARK: - 针对所有repos
    /// 针对所有repos, 删除tag
    static func delete(tag: ObjTag) {
        var changeArr: [ObjRepos] = []
        let findTagStar = SQLStars.findStarRepos(tag: tag)
        if findTagStar != nil && !findTagStar!.isEmpty {
            for item in findTagStar! {
                if let repotags = item.star_tags {
                    if repotags.contains(tag.name!) {
                        item.star_tags?.removeAll(tag.name!)
                        changeArr.append(item)
                    }
                }
            }
        }
        if !changeArr.isEmpty {
            SQLStars.insert(repos: changeArr)
        }
    }
    
    // MARK: - 针对单条repos数据
    /// 针对单条repos, 删除tag字符串对象
    static func delete(repo: ObjRepos, tagObj: ObjTag) {
        if tagObj.name!.isEmpty || repo.id == nil {
            return
        }
        self.delete(repo: repo, tag: tagObj.name!)
    }
    
    /// 针对单条repos, 删除tag字符串
    static func delete(repo: ObjRepos, tag: String) {
        
        if tag.isEmpty || repo.id == nil {
            return
        }
        do {
            if let needUpdateId = repo.id {
                if let repotags = repo.star_tags {
                    var afterDel = repotags
                    //删除tag后的tags
                    if afterDel.contains(tag) {
                        afterDel.removeAll(tag)
                    }
                    if check(id: needUpdateId) {
                        let filterRow = starReposTable.filter(repoId == needUpdateId)
                        _ = try SQLManager.githubDb.run(filterRow.update(star_tags <- SQLHelper.SQLBlob(stringarray: afterDel)))
                    } else {
                        _ = try SQLManager.githubDb.run(starReposTable.insert(SQLStarReposSetters(repos: repo, action: .insert)))
                    }
                    
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: -  根据id删除repo
    static func delete(id: Int) {
        let query = starReposTable.filter(repoId == id)
        do {
            if try SQLManager.githubDb.run(query.delete()) > 0 {
                print("deleted id:\(id)")
            } else {
                print("not found id:\(id)")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
}
