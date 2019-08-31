//
//  SQLStars+Action.swift
//  BeeFun
//
//  Created by WengHengcong on 04/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import SQLite

extension SQLStars {
    
    // MARK: - 获取所有Star项目的语言
    static func getLanguageList() -> [String] {
        var languageArr: [String] = []
        do {
            let query = "SELECT DISTINCT language FROM \(starTableName) ORDER BY language ASC"
            let languageList = try SQLManager.githubDb.prepare(query)
            for item in languageList {
                let lan = item[0] as? String ?? "None"
                if languageArr.contains(lan) {
                    continue
                } else {
                    languageArr.append(lan)
                }
            }
            if languageArr.isEmpty {
                languageArr.append("Swift")
            }
            languageArr.sort { $0 < $1 }
            return languageArr
        } catch {
            return ["Swift"]
        }
        
    }
    
    // MARK: - 检查repos是否存在
    static func check(id: Int) -> Bool {
        let query = starReposTable.where(repoId == id)
        let all = try? SQLManager.githubDb.prepare(query)
        if all != nil {
            for item in all! where (id == item[repoId]) {
                return true
            }
        }
        return false
    }
}
