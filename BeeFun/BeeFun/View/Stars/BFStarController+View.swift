//
//  BFStarController+View.swift
//  BeeFun
//
//  Created by WengHengcong on 26/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

extension BFStarController {
    
    // MARK: - view
    func svc_customViewBeforeGetTags() {
        svc_customNavView()
        svc_setupTableView()
    }
    
    func svc_customViewAfterGetTags() {
        svc_customTagBar()
        svc_customCarouselView()
        svc_customMoreButton()
        svc_customMoreView()
    }
    
    // MARK: - 导航栏选择
    func svc_customNavView() {
        self.title = "Stars".localized
        self.automaticallyAdjustsScrollViewInsets = false
        self.leftItem?.isHidden = true
        navSegmentView = JSSegmentControl(titles: ["Stars".localized, "Watched".localized], frame: CGRect(x: 0, y: 0, w: 150, h: 30))
        navSegmentView?.delegate = self
        self.navigationController?.navigationBar.topItem?.titleView = navSegmentView
    }
    // MARK: - tag栏
    func svc_customTagBar() {
        let tagBarHeight: CGFloat = 35
//        tagBar.sectionTitles = self.starTags
        tagBar.frame = CGRect(x: 0, y: uiTopBarHeight, width: ScreenSize.width-tagBarHeight, height: tagBarHeight)
        tagBar.indexChangeBlock = { index in
            self.tagSegmentControlChange(index: index)
        }
        view.addSubview(tagBar)
    }
    
    // MARK: - carouse 内容视图
    func svc_customCarouselView() {
        let scrollH = ScreenSize.height-uiTopBarHeight
        carouselContent.isHidden = false
        carouselContent.delegate = self
        carouselContent.dataSource = self
        carouselContent.type = .linear
        //        carouselContent.isPagingEnabled = true
        carouselContent.scrollSpeed = 2.5
        carouselContent.decelerationRate = 0.25
        carouselContent.bounceDistance = 0.1
        carouselContent.frame = CGRect(x: 0, y: tagBar.bottom, w: ScreenSize.width, h: scrollH-tagBar.height)
        //        carouselContent.scrollToItem(at: 0, animated: true)
        view.addSubview(carouselContent)
    }
    
    // MARK: - 更多按钮
    func svc_customMoreButton() {
        moreBtn.setImage(UIImage(named: "arrow_down_gray"), for: .normal)
        moreBtn.setImage(UIImage(named: "arrow_up_gray"), for: .highlighted)
        moreBtn.setImage(UIImage(named: "arrow_up_gray"), for: .selected)
        moreBtn.backgroundColor = UIColor.white
        moreBtn.addTarget(self, action: #selector(svc_clickMoreAction(sender:)), for: .touchUpInside)
        moreBtn.frame = CGRect(x: tagBar.right, y: tagBar.top, w: ScreenSize.width-tagBar.width, h: tagBar.height)
        view.addSubview(moreBtn)
    }
    
    // MARK: - 更多页面，显示全部tag按钮
    @objc func svc_customMoreView() {
        moreView.frame = CGRect(x: 0, y: self.tagBar.bottom, w: ScreenSize.width, h: 0)
        //        moreView.isHidden = true
        moreView.backgroundColor = UIColor.bfViewBackgroundColor
        view.addSubview(moreView)
    }
    
    // MARK: - 更多显示/隐藏视图动画
    func svc_moreViewAnimation(show: Bool) {
        let timeInterval = 0.35
        if show {
            UIView.animate(withDuration: timeInterval, animations: {
                self.moreView.frame = CGRect(x: 0, y: self.tagBar.bottom, w: ScreenSize.width, h: ScreenSize.height-uiTopBarHeight)
                self.moreView.setContentOffset(CGPoint.zero, animated: false)
            })
        } else {
            UIView.animate(withDuration: timeInterval, animations: {
                self.moreView.frame = CGRect(x: 0, y: self.tagBar.bottom, w: ScreenSize.width, h: 0)
                self.moreView.setContentOffset(CGPoint.zero, animated: false)
            })
        }
    }
    
    /// 页面退出时，more按钮恢复，more视图隐藏
    func svc_moreViewDisappear() {
        moreBtn.isSelected = false
        svc_moreViewAnimation(show: false)
    }
    // MARK: - 全部标签按钮
    func svc_addAllButtons() {
        
        if allButtons.count > 0 {
            allButtons.removeAll()
            moreView.removeAllSubViews()
        }
        
        for (index, tag) in starTags.enumerated() {
            let tagB = UIButton()
            tagB.tag = index
            tagB.setTitle(tag, for: .normal)
            tagB.setTitleColor(UIColor.black, for: .normal)
            tagB.setTitleColor(UIColor.bfRedColor, for: .selected)
            tagB.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            tagB.radius = 15.0
            tagB.borderWidth = 1.0/UIScreen.main.scale
            tagB.tag = index
            tagB.borderColor = .bfRedColor
            tagB.backgroundColor = UIColor.white
            tagB.addTarget(self, action: #selector(svc_clickTagInMoreView(sender:)), for: .touchUpInside)
            allButtons.append(tagB)
            moreView.addSubview(tagB)
        }
    }
    
    func svc_layoutAllTagsButton() {
        svc_addAllButtons()
        let lineH: CGFloat = 50
        /// 两个按钮之间的间距
        let btnOutsideMargin: CGFloat = 5
        /// 按钮内部两边的间距宽度
        let btnInsideMargin: CGFloat = 20
        /// 按钮的高度
        let btnH: CGFloat = 30
        /// 行间距
        let rowsYMargin: CGFloat = (lineH-btnH)/2.0
        /// 第一列距离边距的长度
        let firstColumnXMargin: CGFloat = 10
        for (index, btn) in allButtons.enumerated() {
            var lastF = CGRect.zero
            var nowY: CGFloat = 10
            var nowX = firstColumnXMargin
            
            if index > 0 {
                lastF = allButtons[index-1].frame
                nowY = lastF.y
                nowX += lastF.x + lastF.width + btnOutsideMargin
            }
            
            var nowW: CGFloat = 0
            if let tagsTitle = btn.currentTitle {
                nowW = tagsTitle.width(with: lineH, font: btn.titleLabel!.font) + btnInsideMargin
            }
            let nextX: CGFloat = nowX + nowW
            if nextX > ScreenSize.width {
                nowY += btnH + rowsYMargin
                nowX = firstColumnXMargin
            }
            let nowF = CGRect(x: nowX, y: nowY, w: nowW, h: btnH)
            btn.frame = nowF
            layoutAllTagButtonChagngeSelState()
        }
        if let lastFrame = allButtons.last?.frame {
            moreView.contentSize = CGSize(width: ScreenSize.width, height: lastFrame.y+lastFrame.height+100)
        } else {
            moreView.contentSize = carouselContent.frame.size
        }
        
    }
    
    func layoutAllTagButtonChagngeSelState() {
        let selindex = tagBar.selectedSegmentIndex
        for btn in allButtons {
            if let tag = btn.currentTitle {
                if selindex < tagBar.sectionTitles.count {
                    if tagBar.sectionTitles[selindex] == tag {
                        btn.isSelected = true
                        btn.borderColor = .bfRedColor
                        btn.backgroundColor = UIColor.white
                    } else {
                        btn.isSelected = false
                        btn.borderColor = UIColor(hex: "#cccbcf")!
                        btn.backgroundColor = UIColor(hex: "#f3f2f5")
                    }
                }
            }
        }
    }
    
    // MARK: - watched table内容视图
    func svc_setupTableView() {
        watchedTableView.frame = CGRect.zero
        watchedTableView.isHidden = true
        watchedTableView.dataSource = self
        watchedTableView.delegate = self
        watchedTableView.separatorStyle = .none
        watchedTableView.backgroundColor = UIColor.bfViewBackgroundColor
        watchedTableView.mj_header = refreshManager.header()
        watchedTableView.mj_footer = refreshManager.footer()
        refreshManager.delegate = self
        if #available(iOS 11, *) {
            watchedTableView.estimatedRowHeight = 0
            watchedTableView.estimatedSectionHeaderHeight = 0
            watchedTableView.estimatedSectionFooterHeight = 0
        }
        view.addSubview(watchedTableView)
        
        let tabH = ScreenSize.height-uiTopBarHeight
        watchedTableView.frame = CGRect(x: 0, y: uiTopBarHeight, w: ScreenSize.width, h: tabH)
    }
}
