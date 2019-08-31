//
//  TrendingManager.swift
//  BeeFun
//
//  Created by WengHengcong on 30/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import Moya

typealias TrendingRepositoriesDone = ((_ repos: [ObjRepos]) -> Void)?
typealias TrendingDevelopersDone = ((_ repos: [ObjUser]) -> Void)?
typealias TrendingShowcasessDone = ((_ repos: [ObjShowcase]) -> Void)?
typealias TrendingShowcasessDetailDone = ((_ repos: [ObjRepos]) -> Void)?

/// 参考： https://www.raywenderlich.com/14172/how-to-parse-html-on-ios
class TrendingManager {
    
    static let shared = TrendingManager()
    
    // MARK: - Trending Reops
    func generateTrendingRepositoriesUrl(since: String, language: String) -> URL {
        //https://github.com/trending?since=weekly
        //https://github.com/trending/java?since=weekly
        var urlStr = "https://github.com/trending"
        if !since.isEmpty && !language.isEmpty {
            if language.lowercased() == "all".localized {
                urlStr = String(format: "https://github.com/trending?since=%@", since.lowercased())
            } else {
                urlStr = String(format: "https://github.com/trending/%@?since=%@", language.lowercased(), since.lowercased())
            }
        }
        guard let trendingURL = URL(string: urlStr) else {
            print("Error: \(urlStr) doesn't seem to be a valid URL")
            let defaultURL = URL(string: "https://github.com/trending")
            return defaultURL!
        }
        
        return trendingURL
    }
    
    func requestForTrendingRepositories(since: String, language: String, done: TrendingRepositoriesDone) {
        
        let trendingURL = generateTrendingRepositoriesUrl(since: since, language: language)
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "get"
//        request.setValue("BeeFun", forHTTPHeaderField: "User-Agent")
//        request.setValue(AppToken.shared.access_token ?? "", forHTTPHeaderField: "Authorization")

        Alamofire.request(request).responseString(completionHandler: { (response) in
            switch response.result {
                case .success:
                    if let htmlSourceStirng = response.result.value {
                        do {
                            //............
                            let doc = try HTML(html: htmlSourceStirng, encoding: .utf8)
                            var reposArr: [ObjRepos] = []
                            for repo in doc.xpath("//ol[@class='repo-list']/li") {
                                let repoStr = repo.content!
                                let orginArr = repoStr.split("\n")
                                var itemArr: [String] = []
                                for value in orginArr {
                                    let trimmedValue = value.trimmed
                                    if trimmedValue != "Star" && trimmedValue != "Unstar" && trimmedValue != "Built by" {
                                        itemArr.append(trimmedValue)
                                    }
                                }
                                
                                let obj = ObjRepos()
                                //owner name/ repo name
                                obj.full_name = itemArr[0]
                                let owner = ObjUser()
                                owner.login = obj.full_name?.split("/")[0].trimmed
                                obj.owner = owner
                                obj.name = obj.full_name?.split("/")[1].trimmed
                                //0、1 默认未name/desc
                                if itemArr.count == 6 {
                                    /*
                                     - 0 : "wearehive / project-guidelines"
                                     - 1 : "A set of best practices for JavaScript projects"
                                     - 2 : "JavaScript"
                                     - 3 : "2,550"
                                     - 4 : "132"
                                     - 5 : "2,033 stars today"
                                     */
                                    obj.cdescription = itemArr[1]
                                    obj.language = itemArr[2]
                                    obj.trending_star_text = itemArr[3]
                                    obj.trending_fork_text = itemArr[4]
                                    obj.trending_star_interval_text = itemArr[5]
                                    
                                } else if itemArr.count == 5 {
                                    obj.cdescription = itemArr[1]
                                    if itemArr[2].isOnlyNumeric {
                                        /*
                                         - 2 : "929"
                                         - 3 : "35"
                                         - 4 : "298 stars today"
                                         */
                                        obj.trending_star_text = itemArr[2]
                                        if itemArr[3].isOnlyNumeric {
                                            obj.trending_fork_text = itemArr[3]
                                        }
                                        if itemArr[4].contains("star") {
                                            obj.trending_star_interval_text = itemArr[4]
                                        }
                                    } else {
                                        /*
                                         - 2 : "          MQL4"
                                         - 3 : "        34"
                                         - 4 : "        2"
                                         */
                                        obj.language = itemArr[2]
                                        if itemArr[3].isOnlyNumeric {
                                            obj.trending_star_text = itemArr[3]
                                        }
                                        if itemArr[4].isOnlyNumeric {
                                            obj.trending_fork_text = itemArr[4]
                                        }
                                    }
                                    
                                } else if itemArr.count == 4 {
                                    /*
                                     - 2 : "          MQL4"
                                     - 3 : "        4"
                                     or
                                     - 2 : "          55"
                                     - 3 : "        4"
                                     or
                                     - 2 : "          4"
                                     - 3 : "        98 stars today"
                                     or
                                     - 0 : "breakermind / Mql4"
                                     - 1 : "MQL4"
                                     - 2 : "7"
                                     - 3 : "11"
                                     */
                                    if itemArr[1].lowercased() == language.lowercased() {
                                        obj.language = itemArr[1]
                                    }
                                    if itemArr[2].isOnlyNumeric {
                                        obj.trending_star_text = itemArr[2]
                                        if itemArr[3].contains("star") {
                                            obj.trending_star_interval_text = itemArr[3]
                                        } else if itemArr[3].isOnlyNumeric {
                                            obj.trending_fork_text = itemArr[3]
                                        }
                                    } else {
                                        obj.language = itemArr[2]
                                        if itemArr[3].isOnlyNumeric {
                                            obj.trending_star_text = itemArr[3]
                                        }
                                    }
                                } else if itemArr.count == 3 {
                                    /*
                                     - 0 : "Lucas170 / Chapter-13-All-Files"
                                     - 1 : "MQL4"
                                     - 2 : "1"
                                     or
                                     - 0 : "Lucas170 / Chapter-13-All-Files"
                                     - 1 : "desc"
                                     - 2 : "1"
                                     or
                                     - 0 : "Lucas170 / Chapter-13-All-Files"
                                     - 1 : "5"
                                     - 2 : "1"
                                     or
                                     - 0 : "Lucas170 / Chapter-13-All-Files"
                                     - 1 : "5"
                                     - 2 : "1 star today"
                                     */
                                    if itemArr[1].lowercased() == language.lowercased() {
                                        obj.language = itemArr[1]
                                        obj.trending_star_text = itemArr[2]
                                    } else if itemArr[1].isOnlyNumeric {
                                        obj.trending_star_text = itemArr[1]
                                        if itemArr[2].isOnlyNumeric {
                                            obj.trending_fork_text = itemArr[2]
                                        } else if  itemArr[3].contains("star") {
                                            obj.trending_star_interval_text = itemArr[2]
                                        }
                                    } else {
                                        obj.cdescription = itemArr[1]
                                        obj.trending_star_text = itemArr[2]
                                    }
                                }
                                reposArr.append(obj)
                            }
                            DispatchQueue.main.async {
                                if let doneCom = done {
                                    doneCom(reposArr)
                                }
                            }
                        //............
                        } catch {
                            
                        }

                }
                case .failure:
                break
            }
        })
    }
    
    // MARK: - Trending Developer
    func generateTrendingDeveloperUrl(since: String, language: String) -> URL {
        //https://github.com/trending/developers/java?since=weekly
        //https://github.com/trending/developers?since=weekly
        var urlStr = "https://github.com/trending/developers"
        if !since.isEmpty && !language.isEmpty {
            if language.lowercased() == "all".localized {
                urlStr = String(format: "https://github.com/trending/developers?since=%@", since.lowercased())
            } else {
                urlStr = String(format: "https://github.com/trending/developers/%@?since=%@", language.lowercased(), since.lowercased())
            }
        }

        guard let trendingURL = URL(string: urlStr) else {
            print("Error: \(urlStr) doesn't seem to be a valid URL")
            let defaultURL = URL(string: "https://github.com/trending")
            return defaultURL!
        }
        
        return trendingURL
    }
    
    func requestForTrendingDeveloper(since: String, language: String, done: TrendingDevelopersDone) {
        let trendingURL = generateTrendingDeveloperUrl(since: since, language: language)
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "get"
//        request.setValue("BeeFun", forHTTPHeaderField: "User-Agent")
//        request.setValue(AppToken.shared.access_token ?? "", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseString(completionHandler: { (response) in
            switch response.result {
            case .success:
                if let htmlSourceStirng = response.result.value {
                    //            print("HTML : \(myHTMLString)")
                    do {
                        //............
                         let doc = try HTML(html: htmlSourceStirng, encoding: .utf8)
                        //                print(doc.title)
                        // Search for nodes by CSS
                        //                for link in doc.css("a, link") {
                        //                    print(link.text)
                        //                    print(link["href"])
                        //                }
                        
                        // Search for nodes by XPath
                        var userArr: [ObjUser] = []
                        for (index, user) in doc.xpath("//div[@class='explore-content']/ol/li").enumerated() {
                            let userStr = user.content!
                            let orginArr = userStr.split("\n")
                            var itemArr: [String] = []
                            for value in orginArr {
                                let trimmedValue = value.trimmed
                                if trimmedValue != "Follow" && trimmedValue != "Unfollow" {
                                    itemArr.append(trimmedValue)
                                }
                            }
                            
                            let obj = ObjUser()
                            /*
                             - 0 : "                    3"
                             - 1 : "                          Bogdan-Lyashenko"
                             */
                            obj.trend_repo_order = itemArr[0].int
                            obj.login = itemArr[1]
                            if itemArr.count == 5 {
                                /*
                                 - 2 : "                              (Bohdan Liashenko)"
                                 - 3 : "      Under-the-hood-ReactJS"
                                 - 4 : "    Entire ReactJS code base explanation by visual block schemes (Stack+Fiber versions) "
                                 */
                                obj.trend_user_name = itemArr[2]
                                obj.trend_repo_name = itemArr[3]
                                obj.trend_repo_desc = itemArr[4]
                            } else if itemArr.count == 4 {
                                /*
                                 - 2 : "      Under-the-hood-ReactJS"
                                 - 3 : "    Entire ReactJS code base explanation by visual block schemes (Stack+Fiber versions) "
                                 */
                                obj.trend_repo_name = itemArr[2]
                                obj.trend_repo_desc = itemArr[3]
                            }
                            //头像
                            let imgXpath = String(format: "(//div[@class='d-flex']/div[@class='mx-2']/a/img)[%d]", index+1)
                            for img in user.xpath(imgXpath) {
                                if let avatarUrl = img["src"] {
                                    obj.avatar_url = avatarUrl
                                }
                            }
                            userArr.append(obj)
                        }
                        DispatchQueue.main.async {
                            if let doneCom = done {
                                doneCom(userArr)
                            }
                        }
                        //............
                    } catch {
                        
                    }
                }
            case .failure:
                break
            }
        })
    }

    // MARK: - Trending Showcase
    
    func generateTrendingShowcaseUrl(page: Int) -> URL {
        //https://github.com/showcases
        //https://github.com/showcases?page=2
        var urlStr = "https://github.com/showcases"
        if page > 1 {
            urlStr = String(format: "https://github.com/showcases?page=%d", page)
        } else {
            urlStr = "https://github.com/showcases"
        }
        
        guard let trendingURL = URL(string: urlStr) else {
            print("Error: \(urlStr) doesn't seem to be a valid URL")
            let defaultURL = URL(string: "https://github.com/trending")
            return defaultURL!
        }
        
        return trendingURL
    }

    func requestForTrendingShowcase(page: Int, done: TrendingShowcasessDone) {
        let trendingURL = generateTrendingShowcaseUrl(page: page)
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "get"
        request.setValue("BeeFun", forHTTPHeaderField: "User-Agent")
        request.setValue(AppToken.shared.access_token ?? "", forHTTPHeaderField: "Authorization")
        Alamofire.request(request).responseString(completionHandler: { (response) in
            switch response.result {
            case .success:
                if let htmlSourceStirng = response.result.value {
                    do {
                        let doc = try HTML(html: htmlSourceStirng, encoding: .utf8)
                        var caseArr: [ObjShowcase] = []
                        for (_, showcase) in doc.xpath("//ul[@class='exploregrid gutter']/li").enumerated() {
                            let userStr = showcase.content!
                            let itemArr = userStr.split("\n")
                            let obj = ObjShowcase()
                            if itemArr.count >= 4 {
                                obj.name = itemArr[0].trimmed
                                obj.cdescription = itemArr[1].trimmed
                                obj.trend_repo_text = itemArr[2].trimmed
                                obj.trend_lan_text = itemArr[3].trimmed
                            }
                            
                            //背景
                            let svgXpath = String(format: "//a/div[@class='exploregrid-item-header']")
                            for svgDiv in showcase.xpath(svgXpath) {
                                if let avatarUrl = svgDiv["style"] {
                                    var base64Content = avatarUrl.replacing("background-image: url(data:image/svg+xml;base64,", with: "")
                                    base64Content = base64Content.replacing(");", with: "")
                                    obj.svgXml = base64Content
                                }
                            }
                            caseArr.append(obj)
                        }
                        DispatchQueue.main.async {
                            if let doneCom = done {
                                doneCom(caseArr)
                            }
                        }
                        
                    } catch {
                        
                    }

                }
            case .failure:
                break
            }
        })
    }
    
    // MARK: - Trending Showcase Detail
    func generateTrendingShowcaseDetailUrl(showcase: String) -> URL {
        //https://github.com/showcases/web-accessibility
        var urlStr = "https://github.com/showcases/swift"
        if !showcase.isEmpty {
            let showcaseTranser = showcase.trimmed.replacing(" ", with: "-")
            urlStr = String(format: "https://github.com/showcases/%@", showcaseTranser)
        } else {
            urlStr = "https://github.com/showcases/swift"
        }
        
        guard let trendingURL = URL(string: urlStr) else {
            print("Error: \(urlStr) doesn't seem to be a valid URL")
            let defaultURL = URL(string: "https://github.com/trending")
            return defaultURL!
        }
        
        return trendingURL
    }
    
    func requestForTrendingShowcaseDetail(showcase: String, done: TrendingShowcasessDetailDone) {
        let trendingURL = generateTrendingShowcaseDetailUrl(showcase: showcase)
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "get"
        request.setValue("BeeFun", forHTTPHeaderField: "User-Agent")
        request.setValue(AppToken.shared.access_token ?? "", forHTTPHeaderField: "Authorization")
        Alamofire.request(request).responseString(completionHandler: { (response) in
            switch response.result {
            case .success:
                if let htmlSourceStirng = response.result.value {
                    
                    do {
                        let doc = try HTML(html: htmlSourceStirng, encoding: .utf8)
                        var reposArr: [ObjRepos] = []
                        for (index, repoLi) in doc.xpath("//ul[@class='repo-list showcase-page-repo-list']/li").enumerated() {
                            let userStr = repoLi.content!
                            let orginArr = userStr.split("\n")
                            
                            var itemArr: [String] = []
                            for value in orginArr {
                                let trimmedValue = value.trimmed.lowercased()
                                if trimmedValue.contains("Starred".lowercased()) || trimmedValue.contains("people".lowercased()) || trimmedValue.contains("know".lowercased()) {
                                } else {
                                    itemArr.append(value.trimmed)
                                }
                            }
                            
                            let obj = ObjRepos()
                            obj.full_name = itemArr[0].trimmed
                            let owner = ObjUser()
                            owner.login = obj.full_name?.split("/")[0].trimmed
                            obj.owner = owner
                            obj.name = obj.full_name?.split("/")[1].trimmed
                            
                            if itemArr.count == 6 {
                                /*
                                 - 0 : "                buunguyen / octotree"
                                 - 1 : "                  Code tree for GitHub"
                                 - 2 : "                    JavaScript"
                                 - 3 : "                  9,355"
                                 - 4 : "                  769"
                                 - 5 : "                  Updated May 16, 2017"
                                 */
                                obj.cdescription = itemArr[1]
                                obj.language = itemArr[2]
                                obj.trending_star_text = itemArr[3]
                                obj.trending_fork_text = itemArr[4]
                                obj.trending_showcase_update_text = itemArr[5]
                                
                                //头像
                                let imgXpath = String(format: "(//ul[@class='repo-list showcase-page-repo-list']/li/a/img)[%d]", index+1)
                                for img in doc.xpath(imgXpath) {
                                    if let avatarUrl = img["src"] {
                                        obj.owner?.avatar_url = avatarUrl
                                    }
                                }
                            } else if itemArr.count == 5 {
                                /*
                                 - 0 : "                sindresorhus / notifier-for-github"
                                 - 1 : "                  Browser extension that displays your GitHub notifications unread count. Available on Chrome, Firefox, Opera, Safari."
                                 - 2 : "                  233"
                                 - 3 : "                  21"
                                 - 4 : "                  Updated Jun 9, 2017"
                                 
                                 or
                                 - 0 : "                bitoiu / github-red-alert"
                                 - 1 : "                  Changes the GitHub notification icon to red if you have unread participating notifications."
                                 - 2 : "                    CoffeeScript"
                                 - 3 : "                  3"
                                 - 4 : "                  Updated Oct 31, 2016"
                                 */
                                obj.cdescription = itemArr[1]
                                //无语言
                                if itemArr[2].trimmed.isOnlyNumeric {
                                    obj.trending_star_text = itemArr[2]
                                    obj.trending_fork_text = itemArr[3]
                                    obj.trending_showcase_update_text = itemArr[4]
                                } else {
                                    //有语言，只读star
                                    obj.language = itemArr[2]
                                    obj.trending_star_text = itemArr[3]
                                    obj.trending_showcase_update_text = itemArr[4]
                                }
                                
                                //头像
                                let imgXpath = String(format: "(//ul[@class='repo-list showcase-page-repo-list']/li/a/img)[%d]", index+1)
                                for img in doc.xpath(imgXpath) {
                                    if let avatarUrl = img["src"] {
                                        obj.owner?.avatar_url = avatarUrl
                                    }
                                }
                            }
                            reposArr.append(obj)
                        }
                        DispatchQueue.main.async {
                            if let doneCom = done {
                                doneCom(reposArr)
                            }
                        }
                        

                    } catch {
                        
                    }
                    
                }
            case .failure:
                break
            }
        })
    }

}
