//
//  BFTrendingController+Data.swift
//  BeeFun
//
//  Created by WengHengcong on 25/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//
import ObjectMapper
import Alamofire

extension BFTrendingController {
    // MARK: - 从plist中获取用语filter的数据
    func tvc_getDataFromPlist() {
        
        if let path = Bundle.appBundle.path(forResource: "CPCity", ofType: "plist") {
            cityArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = Bundle.appBundle.path(forResource: "BFLanguage", ofType: "plist") {
            languageArr = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = Bundle.appBundle.path(forResource: "CPCountry", ofType: "plist") {
            countryArr = NSArray(contentsOfFile: path)! as? [String]
        }
    }
    
    // MARK: 获取repos数据
    func tvc_getReposRequest() {
        
        requesDeveloperModel?.language = paraLanguage
        requesDeveloperModel?.time = BFGihubTrendingTimeEnum(rawValue: paraSince)
        
        _ = JSMBHUDBridge.showHud(view: self.view)
        BeeFunProvider.sharedProvider.request(BeeFunAPI.getGithubTrending(model: requesRepostModel!), callbackQueue: DispatchQueue.main, progress: { (progress) in
            print(progress.progress)
        }) { (result) in

            self.removeReloadView()
            JSMBHUDBridge.hideAllHudInView(view: self.view)
            
            switch result {
            case let .success(response):
                do {
                    if let reposResponse = Mapper<BeeFunTrendingResponseModel>().map(JSONObject: try response.mapJSON()) {
                        if let code = reposResponse.codeEnum, code == BFStatusCode.bfOk {
                            if let data = reposResponse.data {
                                self.reposData.removeAll()
                                self.reposData = data
                                self.displayTableView?.reloadData()
                            }
                        }
                    }
                } catch {
                }
                break
            case .failure:
                break
            }
        }
    }
    // MARK: 获取用户数据
    func tvc_getUserRequest() {
        
        requesDeveloperModel?.language = paraLanguage
        requesDeveloperModel?.time = BFGihubTrendingTimeEnum(rawValue: paraSince)
        
        _ = JSMBHUDBridge.showHud(view: self.view)
        BeeFunProvider.sharedProvider.request(BeeFunAPI.getGithubTrending(model: requesDeveloperModel!)) { (result) in
            JSMBHUDBridge.hideAllHudInView(view: self.view)
            switch result {
            case let .success(response):
                do {
                    if let reposResponse = Mapper<BeeFunTrendingResponseModel>().map(JSONObject: try response.mapJSON()) {
                        if let code = reposResponse.codeEnum, code == BFStatusCode.bfOk {
                            if let data = reposResponse.data {
                                DispatchQueue.main.async {
                                    self.removeReloadView()
                                    self.devesData.removeAll()
                                    self.devesData = data
                                    self.displayTableView?.reloadData()
                                }
                            }
                      
                        }
                    }
                } catch {
                }
                break
            case .failure:
                break
            }
        }
    }
    
    // MARK: 获取showcase数据
    func tvc_getShowcasesRequest(page: Int) {
        
        _ = JSMBHUDBridge.showHud(view: self.view)
        TrendingManager.shared.requestForTrendingShowcase(page: page) { (showcase) in
            DispatchQueue.main.async { 
                JSMBHUDBridge.hideAllHudInView(view: self.view)
                self.removeReloadView()
                if showcase.isEmpty {
                    return
                }
                if page == 1 {
                    self.showcasesData.removeAll()
                    self.showcasesData = showcase
                } else {
                    self.showcasesData += showcase
                }
                self.displayTableView?.reloadData()
            }
        }
    }
}
