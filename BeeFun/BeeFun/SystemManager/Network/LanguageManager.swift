//
//  LanguageManager.swift
//  BeeFun
//
//  Created by WengHengcong on 11/07/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import Moya

/// 语言生成器
class LanguageManager {

    static let shared = LanguageManager()

    func generateLanguage() -> URL {
        let urlStr = "https://github.com/trending"
        guard let trendingURL = URL(string: urlStr) else {
            print("Error: \(urlStr) doesn't seem to be a valid URL")
            let defaultURL = URL(string: "https://github.com/trending")
            return defaultURL!
        }
        return trendingURL
    }
    
    func requestForLanguage() {
        
        var languageArr: [String]? = []
        let trendingURL = generateLanguage()
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
                        for repo in doc.xpath("//div[@class='select-menu js-menu-container js-select-menu']/div/div/div/div/a") {
                            let repoStr = repo.content!
                            let language = repoStr.trimmed
                            if languageArr != nil {
                                languageArr?.append(language)
                            }
                        }
                        DispatchQueue.main.async {
                            let nsArr = NSArray(array: languageArr!)
                            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                            if let documentDirectory = paths[0] as? String {
                                let path = documentDirectory.appending("/lan.plist")
                                let fail = nsArr.write(toFile: path, atomically: true)
                                if fail {
                                    
                                }
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
