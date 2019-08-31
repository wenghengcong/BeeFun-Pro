//
//  SESearchResultController.swift
//  BeeFun
//
//  Created by WengHengcong on 05/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import HMSegmentedControl
import iCarousel

class SESearchResultController: BFBaseViewController, SESearchResultContentDelegate, iCarouselDataSource, iCarouselDelegate {

    var searchKey: String?
    //导航栏
    lazy var searchBar = JSSearchBar(frame: CGRect(x: 10, y: 0, width: ScreenSize.width-100, height: 28))
    //筛选视图
    var filterBarView: UIView = UIView()
    var filterButtons: [SESearchOrderButton] = []
    
    //结果分类视图
    var segControl: HMSegmentedControl! = JSHMSegmentedBridge.segmentControl(titles: ["Repositories".localized, "Users".localized, "Issues".localized])
    //语言选择视图
    lazy var languageTable = UITableView()
    lazy var maskView = UIView()
    let languageTabWidth = ScreenSize.width - 130
    var popularLanguage: [String]? = []
    var allLanguage: [String]? = []
    var otherLanguage: [String]? = []

    //carousel
    var carouselContent: iCarousel = iCarousel()
    var clickTag: Bool = false
    
    var currentIndex: Int {
        if carouselContent.currentItemIndex < 0 || carouselContent.currentItemIndex >= segControl.sectionTitles.count {
            return 0
        }
        return carouselContent.currentItemIndex
    }
    
    //search parameter
    var firstRequest: Bool = true
    
    var currentSearchModel: SESearchBaseModel {
        set {}
        get {
            if models != nil {
                return models![currentIndex]
            } else {
                return SESearchBaseModel()
            }
        }
    }
    var searchRepoModel: SESearchRepoModel = SESearchRepoModel()
    var searchUserModel: SESearchUserModel = SESearchUserModel()
    var searchIssueModel: SESearchIssueModel = SESearchIssueModel()
    var searchCodeModel: SESearchCodeModel = SESearchCodeModel()
    var searchCommitModel: SESearchCommitModel = SESearchCommitModel()
    var searchWikiModel: SESearchWikiModel = SESearchWikiModel()
    var models: [SESearchBaseModel]?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        srvc_loadData()
        srvc_loadSearchModel()
        srvc_setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        srvc_dismissSearchKeyboard()
        self.languageTable.isHidden = true
    }
    
    // MARK: - Data
    func srvc_loadData() {
        //语言数据记载
        if let path = Bundle.appBundle.path(forResource: "BFPopularLanguage", ofType: "plist") {
            popularLanguage = NSArray(contentsOfFile: path)! as? [String]
        }
        
        if let path = Bundle.appBundle.path(forResource: "BFLanguage", ofType: "plist") {
            allLanguage = NSArray(contentsOfFile: path)! as? [String]
        }
        
        otherLanguage = allLanguage!.difference(popularLanguage!)
    }
    
    func srvc_searchRequestURL(type: SESearchType) -> String {
        var url = "repositories"
        switch type {
        case .repo:
            url = "repositories"
        case .user:
            url = "users"
        case .issue:
            url = "issues"
        case .wiki:
            url = ""
        case .commit:
            url = "commits"
        case .code:
            url = "code"
        }
        return url
    }
    
    func srvc_loadSearchModel() {
        models = [searchRepoModel, searchUserModel, searchIssueModel]
        for (index, model) in models!.enumerated() {
            model.keyword = searchKey
            model.perPage = 10
            model.page = 1
            model.type = SESearchType(rawValue: index)!
            model.requestUrl = srvc_searchRequestURL(type: model.type)
        }
    }
    
    func resetAllSearchModel() {
        for model in models! {
            model.keyword = searchKey
            model.page = 1
        }
    }
}

// MARK: - SESearchResultContentDelegate
extension SESearchResultController {
    func contentViewDidScroll(_ conetView: SESearchResultContentView) {
        srvc_disappearKeyboardAndFilterView()
    }
    
    func contentView(_ contentView: SESearchResultContentView, didSelectRowAt indexPath: IndexPath) {
        srvc_disappearKeyboardAndFilterView()
    }
}

// MARK: - table view
extension SESearchResultController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? popularLanguage!.count : otherLanguage!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "Language"
        let row = indexPath.row
        let section = indexPath.section
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? BFSwipeCell
        if cell == nil {
            cell = BFSwipeCell(style: .default, reuseIdentifier: cellId)
        }
        cell?.textLabel?.font = UIFont.smallSizeSystemFont()
        if section == 0 {
            cell?.textLabel?.text = popularLanguage![row]
        } else {
            cell?.textLabel?.text = otherLanguage![row]
        }
        cell?.textLabel?.textColor = UIColor.iOS11Black
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Popular" : "Everything else"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //视图重置刷新
        tableView.deselectRow(at: indexPath, animated: true)
        srvc_disappearKeyboardAndFilterView()
        currentSearchModel = models![currentIndex]
        currentSearchModel.page = 1
        var lanStr = ""
        if indexPath.section == 0 {
            lanStr = popularLanguage![indexPath.row].lowercased()
        } else {
            lanStr = otherLanguage![indexPath.row].lowercased()
        }
        currentSearchModel.languagePara = lanStr
        reloadCarouselData(forceRefresh: true)
    }
}
