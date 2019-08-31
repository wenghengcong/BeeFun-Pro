//
//  SESearchResultController+View.swift
//  BeeFun
//
//  Created by WengHengcong on 07/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

enum SESearchResultFilterButtonType: Int {
    case language = 0
    case more
    //Repo
    case stars
    case forks
//    case updated
    //User
    case followers
    case repositories
    case joined
    //Issue
    case comments
    case created
    case updated
}

extension SESearchResultController {

    func srvc_setupView() {
        view.backgroundColor = UIColor.white
        srvc_setupNav()
        srvc_setupFilterBarView()
        srvc_setupLanguageTableView()
        srvc_setupSegmentControl()
        srvc_setupCarouselView()
        srvc_dismissSearchKeyboard()
    }
    
    func srvc_setupNav() {
        title = searchKey ?? "Search".localized
        if #available(iOS 11.0, *) {
            searchBar.keepBeforeStyle = true
        }
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchBar.placeholder = "Search".localized
        searchBar.text = searchKey
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        rightItemImage = UIImage(named: "nav_cancel")
        rightItem?.isHidden = false
    }
    
    func srvc_setupFilterBarView() {
        let filterBarH: CGFloat = 40
        filterBarView.frame = CGRect(x: 0, y: uiTopBarHeight, w: ScreenSize.width, h: filterBarH)
        filterBarView.addBorderSingle(at: .bottom)
        view.addSubview(filterBarView)

        let btnW = ScreenSize.width/5.0
        
        let lanW = filterBarH-15
        let lagY = (filterBarH-lanW)/2.0
        let lanBtn = UIButton(frame: CGRect(x: (btnW-lanW)/2.0-10, y: lagY, w: lanW, h: lanW))
        lanBtn.setImage(UIImage(named: "se_lang_switch"), for: .normal)
        lanBtn.tag = SESearchResultFilterButtonType.language.rawValue
        lanBtn.addTarget(self, action: #selector(srvc_filterBtnClick(sender:)), for: .touchUpInside)
        filterBarView.addSubview(lanBtn)
        
        let starBtn = SESearchOrderButton(title: "Stars".localized, frame: CGRect(x: btnW, y: 0, w: btnW, h: filterBarH))
        starBtn.tag = SESearchResultFilterButtonType.stars.rawValue
        starBtn.addTarget(self, action: #selector(srvc_filterBtnClick(sender:)), for: .touchUpInside)
        filterBarView.addSubview(starBtn)
        filterButtons.append(starBtn)
        
        let forkBtn = SESearchOrderButton(title: "Forks".localized, frame: CGRect(x: starBtn.right, y: 0, w: btnW, h: filterBarH))
        forkBtn.tag = SESearchResultFilterButtonType.forks.rawValue
        forkBtn.addTarget(self, action: #selector(srvc_filterBtnClick(sender:)), for: .touchUpInside)
        filterBarView.addSubview(forkBtn)
        filterButtons.append(forkBtn)
        
        let updatedBtn = SESearchOrderButton(title: "Updated".localized, frame: CGRect(x: forkBtn.right, y: 0, w: btnW, h: filterBarH))
        updatedBtn.tag = SESearchResultFilterButtonType.updated.rawValue
        updatedBtn.addTarget(self, action: #selector(srvc_filterBtnClick(sender:)), for: .touchUpInside)
        filterBarView.addSubview(updatedBtn)
        filterButtons.append(updatedBtn)
    }
    
    func srvc_resetFilterButtons() {
        for (index, btn) in filterButtons.enumerated() {
            btn.resetState()
            if currentIndex == 0 {
                if index == 0 {
                    btn.title = "Stars".localized
                    btn.tag = SESearchResultFilterButtonType.stars.rawValue
                } else if index == 1 {
                    btn.title = "Forks".localized
                    btn.tag = SESearchResultFilterButtonType.forks.rawValue
                } else if index == 2 {
                    btn.title = "Updated".localized
                    btn.tag = SESearchResultFilterButtonType.updated.rawValue
                }
            } else if currentIndex == 1 {
                if index == 0 {
                    btn.title = "Followers".localized
                    btn.tag = SESearchResultFilterButtonType.followers.rawValue
                } else if index == 1 {
                    btn.title = "Repos".localized
                    btn.tag = SESearchResultFilterButtonType.repositories.rawValue
                } else if index == 2 {
                    btn.title = "Joined".localized
                    btn.tag = SESearchResultFilterButtonType.joined.rawValue
                }
            } else if currentIndex == 2 {
                if index == 0 {
                    btn.title = "Comments".localized
                    btn.tag = SESearchResultFilterButtonType.comments.rawValue
                } else if index == 1 {
                    btn.title = "Created".localized
                    btn.tag = SESearchResultFilterButtonType.created.rawValue
                } else if index == 2 {
                    btn.title = "Updated".localized
                    btn.tag = SESearchResultFilterButtonType.updated.rawValue
                }
            }
        }
    }
    
    func srvc_setupSegmentControl() {
        segControl.frame = CGRect(x: 0, y: filterBarView.bottom, width: ScreenSize.width, height: 35)
        segControl.indexChangeBlock = { index in
            self.segmentControlChange(index: index)
        }
        view.addSubview(segControl)
    }
    
    // MARK: - carouse 内容视图
    func srvc_setupCarouselView() {
        let scroolY = segControl.bottom
        let scroolH = ScreenSize.height-scroolY-3
        
        carouselContent.isHidden = false
        carouselContent.delegate = self
        carouselContent.dataSource = self
        carouselContent.type = .linear
        //        carouselContent.isPagingEnabled = true
        carouselContent.decelerationRate = 0.5
        carouselContent.frame = CGRect(x: 0, y: scroolY, w: ScreenSize.width, h: scroolH)
        //        carouselContent.scrollToItem(at: 0, animated: true)
        view.addSubview(carouselContent)
    }
    
    // MARK: - Language table
    func srvc_setupLanguageTableView() {
        languageTable.frame = CGRect(x: -languageTabWidth, y: filterBarView.bottom, w: languageTabWidth, h: ScreenSize.height-filterBarView.bottom)
        languageTable.delegate = self
        languageTable.dataSource = self
        languageTable.addBorderSingle(at: .right)
        languageTable.separatorStyle = .singleLine
        if #available(iOS 11, *) {
            languageTable.estimatedRowHeight = 0
            languageTable.estimatedSectionHeaderHeight = 0
            languageTable.estimatedSectionFooterHeight = 0
        }
        view.addSubview(languageTable)
        view.bringSubview(toFront: languageTable)
        
        maskView.backgroundColor = UIColor.iOS11Black
//        view.addSubview(maskView)
    }
    
    func srvc_showLanguageTableView() {
        view.bringSubview(toFront: languageTable)
        languageTable.isHidden = false
        UIView.animate(withDuration: 0.25) {
            let lanFrame = CGRect(x: 0, y: self.filterBarView.bottom, w: self.languageTabWidth, h: ScreenSize.height-self.filterBarView.bottom)
            _ =  CGRect(x: self.languageTabWidth, y: self.filterBarView.bottom, w: ScreenSize.width-self.languageTabWidth, h: self.languageTable.height)
            self.languageTable.frame = lanFrame
//            self.maskView.frame = maskFrame
        }
    }
    
    // MARK: - 消失
    /// 键盘及筛选语言视图均消失
    func srvc_disappearKeyboardAndFilterView() {
        srvc_dismissSearchKeyboard()
        srvc_hideLanguageTableView()
    }
    
    /// 筛选语言视图消息
    func srvc_hideLanguageTableView() {
        languageTable.isHidden = true
        UIView.animate(withDuration: 0.25) {
            let maskW = ScreenSize.width-self.languageTabWidth
            let lanFrame = CGRect(x: -ScreenSize.width, y: self.filterBarView.bottom, w: self.languageTabWidth, h: ScreenSize.height-self.filterBarView.bottom)
            _ = CGRect(x: -maskW, y: self.filterBarView.bottom, w: maskW, h: self.languageTable.height)
            self.languageTable.frame = lanFrame
//            self.maskView.frame = maskFrame
        }
    }

    /// 键盘消失
    func srvc_dismissSearchKeyboard() {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        view.endEditing(true)
        view.resignFirstResponder()
    }
}
