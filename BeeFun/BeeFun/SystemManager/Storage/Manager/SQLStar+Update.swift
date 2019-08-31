//
//  SQLStar+Update.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/2/1.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import SQLite

extension SQLStars {
    
    // MARK: - 插入整条repo数据
    
    /// 插入一个repos数组
    static func insert(repos: [ObjRepos]) {
        assert(!repos.isEmpty)
        do {
            try SQLManager.githubDb.transaction {
                for repo in repos {
                    insert(repo: repo)
                }
            }
        } catch {
            
        }
        
    }
    
    /// 插入一个repos对象
    static func insert(repo: ObjRepos) {
        do {
            assert(repo.id != nil )
            assert(repo.owner?.id != nil)
            if check(id: repo.id!) {
                let filterRow = starReposTable.filter(repoId == repo.id!)
                _ = try SQLManager.githubDb.run(filterRow.update(SQLStarReposSetters(repos: repo, action: .update)))
                //                print("stars table updated id: \(repoId)")
            } else {
                _ = try SQLManager.githubDb.run(starReposTable.insert(SQLStarReposSetters(repos: repo, action: .insert)))
                //                print("stars table inserted id: \(repoId)")
            }
        } catch {
            print("stars table insertion failed: \(error)")
        }
    }
    
    // MARK: - 针对所有Repos更新tag
    /// 针对所有Repos，从旧tag更新到新tag
    static func update(orginal from: ObjTag, change to: ObjTag) {
        do {
            let all = Array(try SQLManager.githubDb.prepare(starReposTable))
            for item in all {
                let tags = SQLHelper.stringArray(blob: item[star_tags])
                if tags.contains(from.name!) {
                    let obj = convertObjRepos(item: item)
                    let oriIndex = obj.star_tags!.index(of: from.name!)
                    obj.star_tags![oriIndex!] = to.name!
                    
                    if let eachId = obj.id {
                        if check(id: eachId) {
                            let filterRow = starReposTable.filter(repoId == eachId)
                            _ = try SQLManager.githubDb.run(filterRow.update(star_tags <- SQLHelper.SQLBlob(stringarray: obj.star_tags)))
                        } else {
                            _ = try SQLManager.githubDb.run(starReposTable.insert(SQLStarReposSetters(repos: obj, action: .insert)))
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - 针对单个repos更新tag
    /// 根据tag 字符串数组更新repos数据
    static func update(repo: ObjRepos, tags: [String]) {
        if tags.isEmpty || repo.id == nil {
            return
        }
        do {
            if let needUpdateId = repo.id {
                if check(id: needUpdateId) {
                    let filterRow = starReposTable.filter(repoId == needUpdateId)
                    _ = try SQLManager.githubDb.run(filterRow.update(star_tags <- SQLHelper.SQLBlob(stringarray: tags)))
                } else {
                    _ = try SQLManager.githubDb.run(starReposTable.insert(SQLStarReposSetters(repos: repo, action: .insert)))
                }
            }
        } catch {
            print(error)
        }
    }

    
    /// 根据tag对象类更新repos数据
    static func update(repo: ObjRepos, tagObjs: [ObjTag]) {
        if tagObjs.isEmpty || repo.id == nil {
            return
        }
        var startags: [String] = []
        for obj in tagObjs {
            startags.append(obj.name!)
        }
        self.update(repo: repo, tags: startags)
    }
}
