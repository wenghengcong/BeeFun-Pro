//
//  SQLStars+Find.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/2/1.
//  Copyright © 2018年 LuCi. All rights reserved.
//

import SQLite

enum StarOrderType: Int {
    case time = 0
    case star = 1
    case a_z = 2
}

extension SQLStars {
    
    // MARK: - 粗粒度查询——根据是否打标签
    
    /// 查找全部Star repos
    static func findAllStar() -> [ObjRepos]? {
        var reposArr: [ObjRepos] = []
        do {
            let all = Array(try SQLManager.githubDb.prepare(starReposTable))
            for item in all {
                let repo = convertObjRepos(item: item)
                reposArr.append(repo)
            }
            return reposArr
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 查找全部untagged repos
    static func findUntaggedStar() -> [ObjRepos]? {
        var untaggedRepo: [ObjRepos] = []
        do {
            let all = Array(try SQLManager.githubDb.prepare(starReposTable))
            var obj: ObjRepos = ObjRepos()
            for item in all {
                obj = convertObjRepos(item: item)
                if let startags = obj.star_tags {
                    if startags.isEmpty {
                        untaggedRepo.append(obj)
                    }
                } else {
                    untaggedRepo.append(obj)
                }
            }
            return untaggedRepo
        } catch {
            print(error)
            return nil
        }
    }
    
    // MARK: - 细粒度查询——根据repos id查询
    
    /// 根据id查找repos对象
    static func find(id: Int) -> ObjRepos? {
        let query = starReposTable.where(repoId == id)
        let all = try? SQLManager.githubDb.prepare(query)
        var obj: ObjRepos = ObjRepos()
        if all != nil {
            for item in all! {
                obj = convertObjRepos(item: item)
                return obj
            }
        }
        return nil
    }
    
    // MARK: - 综合查询
    /// 根据编程员以及排序查询repos
    ///
    /// - Parameters:
    ///   - lang: 编程语言
    ///   - order: 排序
    static func find(lang: String, order: StarOrderType) -> [ObjRepos]? {
        var reposArr: [ObjRepos] = []
        var obj: ObjRepos = ObjRepos()
        
        var myFilter = Expression<Bool?>(value: true)
        if lang == "All" {
            
        } else {
            myFilter = myFilter && (language == lang)
        }
        
        var query = starReposTable.filter(myFilter)
        switch order {
        case .time:
            query = starReposTable.filter(myFilter).order(starred_at.desc)
        case .star:
            query = starReposTable.filter(myFilter).order(stargazers_count.desc)
        case .a_z:
            query = starReposTable.filter(myFilter).order(name.asc)
        }
        
        let all = try? SQLManager.githubDb.prepare(query)
        if all != nil {
            for item in all! {
                obj = convertObjRepos(item: item)
                reposArr.append(obj)
            }
        }
        return reposArr
    }
    
    
    /// 查询
    ///
    /// - Parameters:
    ///   - lang: 编程语言
    ///   - order: 排序
    ///   - tags: 标签
    ///   - all: 是否在全部repos中查询
    ///   - untagged: 是否在全部未有标签中查询
    static func find(lang: String, order: StarOrderType, tags: [ObjTag], all: Bool, untagged: Bool) -> [ObjRepos]? {
        
        var reposArr: [ObjRepos] = []
        var objRepo: ObjRepos = ObjRepos()
        
        var tagString: [String] = []
        if !tags.isEmpty {
            for tag in tags {
                tagString.append(tag.name!)
            }
        }
        
        var myFilter = Expression<Bool?>(value: true)
        if lang == "All" {
            
        } else {
            myFilter = myFilter && (language == lang)
        }
        
        var query = starReposTable.filter(myFilter)
        switch order {
        case .time:
            query = starReposTable.filter(myFilter).order(starred_at.desc)
        case .star:
            query = starReposTable.filter(myFilter).order(stargazers_count.desc)
        case .a_z:
            query = starReposTable.filter(myFilter).order(name.asc)
        }
        
        let allRepo = try? SQLManager.githubDb.prepare(query)
        if allRepo != nil {
            for item in allRepo! {
                objRepo = convertObjRepos(item: item)
                if untagged {
                    //未标记
                    if let startags = objRepo.star_tags {
                        if startags.isEmpty {
                            reposArr.append(objRepo)
                        }
                    } else {
                        reposArr.append(objRepo)
                    }
                } else if all {
                    //全部
                    reposArr.append(objRepo)
                } else {
                    //某几个tag下
                    if tags.count == 0 {
                        reposArr.append(objRepo)
                    } else {
                        let startags = SQLHelper.stringArray(blob: item[star_tags])
                        for tagsFromRepo in startags {
                            if tagString.contains(tagsFromRepo) {
                                reposArr.append(objRepo)
                            }
                        }
                    }
                }
            }
        }
        return reposArr
    }
    
    // MARK: - 根据Tag查询
    
    /// 查找tag下的所有repos
    static func findStarRepos(tag: ObjTag) -> [ObjRepos]? {
        var reposArr: [ObjRepos] = []
        do {
            let all = Array(try SQLManager.githubDb.prepare(starReposTable))
            for item in all {
                let tags = SQLHelper.stringArray(blob: item[star_tags])
                if tags.contains(tag.name!) {
                    let obj = convertObjRepos(item: item)
                    reposArr.append(obj)
                }
            }
            return reposArr
            
        } catch {
            print(error)
            return nil
        }
    }
    
    /// 查找tags下的所有repos
    static func findStarRepos(tags: [ObjTag]) -> [ObjRepos]? {
        assert(!tags.isEmpty)
        var reposArr: [ObjRepos] = []
        var tagString: [String] = []
        for tag in tags {
            tagString.append(tag.name!)
        }
        do {
            let all = Array(try SQLManager.githubDb.prepare(starReposTable))
            for item in all {
                let tags = SQLHelper.stringArray(blob: item[star_tags])
                if tags.contains(tagString) {
                    let obj = convertObjRepos(item: item)
                    reposArr.append(obj)
                }
            }
            return reposArr
            
        } catch {
            print(error)
            return nil
        }
    }
}
