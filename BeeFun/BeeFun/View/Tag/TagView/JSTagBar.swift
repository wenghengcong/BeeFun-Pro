//
//  TagScrollView.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

protocol JSTagBarTouchProtocol: class {
    func touchIetm(item: JSTagItem, index: Int)
    func touchMore(more: UIButton, expend: Bool)
}

class JSTagBar: UIView, UIScrollViewDelegate, JSTagItemTouchProtocol {
    
    var tagWidth: CGFloat = 50
    
    weak var delegate: JSTagBarTouchProtocol?

    var titles: [String] = [] {
        didSet {
            createTagItems()
        }
    }
    
    var currentIndex: Int {
        set {
            setSelectedItem(index: currentIndex)
        }
        get {
            return selIndex
        }
    }
    
    fileprivate var selIndex: Int = 0
    
    var tagItems: [JSTagItem] = [] {
        didSet {
            
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        // 是否支持滑动最顶端
        //    scrollView.scrollsToTop = false;
        scroll.delegate = self
        // 是否反弹
        scroll.bounces = true
        // 是否分页
        //        scrollView.isPagingEnabled = true
        // 是否滚动
        //    scrollView.scrollEnabled = false;
        // 设置内容的边缘
        //    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
        scroll.showsHorizontalScrollIndicator = false
        // 设置indicator风格
        //    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        //    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
        // 提示用户,Indicators flash
        //        scrollView.flashScrollIndicators()
        // 是否同时运动,lock
        //        scrollView.isDirectionalLockEnabled = true

        return scroll
    }()
    
    lazy var moreImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"arrow_down_gray"), for: .normal)
        button.setImage(UIImage(named:"arrow_up_gray"), for: .selected)
        button.addTarget(self, action: #selector(touchMore(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollViewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let moreW: CGFloat = self.height
        let moreX = self.width - moreW
        
        moreImage.frame = CGRect(x: moreX, y: 0, w: moreW, h: self.height)
        
        let scroolW = self.width-moreW
        scrollView.frame = CGRect(x: 0, y: 0, w: scroolW, h: self.height)
        
        var allContentWidth: CGFloat = 0
        for tagItem in self.tagItems {
            tagItem.frame = CGRect(x: allContentWidth, y: 0, w: tagItem.width, h: self.height)
            allContentWidth += tagItem.contentWidth
        }
        
        if allContentWidth >= scroolW {
            scrollView.contentSize = CGSize(width: allContentWidth, height: self.height)
        }
    }
    
    func scrollViewInit() {

        backgroundColor = UIColor.bfViewBackgroundColor
        addSubview(moreImage)
        
        let moreW: CGFloat = self.height
        let scroolW = self.width-moreW
        scrollView.frame = CGRect(x: 0, y: 0, w: scroolW, h: self.height)
        scrollView.contentSize = CGSize(width: self.width, height: self.height)
        addSubview(scrollView)
    }
    
    func createTagItems() {
        assert(!self.titles.isEmpty, "JSTagBar titles can't empty")
        
        for (index, title) in self.titles.enumerated() {
            let tagItem = JSTagItem(title: title)
            tagItem.tag = index
            tagItem.delegate = self
            tagItems.append(tagItem)
            scrollView.addSubview(tagItem)
        }
        currentIndex = 0
        setNeedsDisplay()
    }
    
    /// 选中某一个Item
    ///
    /// - Parameters:
    ///   - index: item的index
    func touchTag(sender: JSTagItem, index: Int) {
        for tagItem in self.tagItems where tagItem.tag != index {
            //选中的不是当前选中的
            tagItem.setTagUnselected()
        }
        selIndex = index
        self.delegate?.touchIetm(item: sender, index: index)
    }
    
    /// 选中More
    ///
    @objc func touchMore(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.touchMore(more: sender, expend: sender.isSelected)
    }
    
    func setSelectedItem(index: Int) {
        if self.tagItems.isEmpty || index < 0 {
            return
        }
        
        if !self.tagItems.isBeyond(index: index) {
            for tagItem in self.tagItems {
                if tagItem.tag != index {
                    //选中的不是当前选中的
                    tagItem.setTagUnselected()
                } else {
                    let item = self.tagItems[index]
                    item.isSelected = true
                }
            }
        }
    }
    
    // 是否支持滑动至顶部
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    // 滑动到顶部时调用该方法
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }
    
    // scrollView 已经滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
    
    // scrollView 开始拖动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")

    }
    
    // scrollView 结束拖动
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")

    }

    // scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
    }
    
    // scrollview 减速停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")

    }
}
