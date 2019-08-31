//
//  JSSegmentControl.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/5/11.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

protocol JSSegmentControlProtocol: class {
    func selectedSegmentContrlol(segment: JSSegmentControl, index: Int)
}
/// 导航栏横滑的segment control
class JSSegmentControl: UIView {
    /// 初始化的时候，不调用didSet
    var titles: [String] {
        didSet {
            didSetSegmentTitles()
        }
    }
    var selIndex: Int = 0
    var backgroundImage: UIImageView = UIImageView(image: UIImage(named: "nav_seg_nor"))
    var segButtons: [UIButton]?
    
    weak var delegate: JSSegmentControlProtocol?
    
    override init(frame: CGRect) {
        self.titles = []
        super.init(frame: frame)
        segmentViewInit()
    }
    
    convenience init(titles: [String]) {
        self.init(titles: titles, frame: CGRect.zero)
    }
    
    convenience init(titles: [String], frame: CGRect) {
        self.init(frame: frame)
        // 注意：初始化的时候，不调用didSet
        self.titles = titles
        didSetSegmentTitles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func segmentViewInit() {
        self.addSubview(backgroundImage)
        backgroundImage.frame = self.frame
    }
    
    func didSetSegmentTitles() {
        assert(!self.titles.isEmpty, "titles can't empty")
        segButtons = []
        for (index, title) in titles.enumerated() {
            let segBtn = UIButton()
            segBtn.tag = index
            segBtn.setTitle(title, for: .normal)
            segBtn.setTitle(title, for: .highlighted)
            segBtn.setTitleColor(UIColor.white, for: .normal)
            segBtn.setTitleColor(UIColor.bfRedColor, for: .selected)
            segBtn.titleLabel?.font = UIFont.bfSystemFont(ofSize: 15.0)
            segBtn.titleLabel?.adjustFontSizeToFitWidth(minScale: 0.5)
            segBtn.setBackgroundImage(UIImage(named: "nav_seg_sel"), for: .selected)
            segBtn.setBackgroundImage(UIImage(named: "nav_seg_sel"), for: .highlighted)
            segBtn.addTarget(self, action: #selector(didSelectedSegment(sender:)), for: .touchUpInside)
            segButtons?.append(segBtn)
            self.addSubview(segBtn)
        }
        self.segButtons?.first?.isSelected = true
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        if !self.titles.isEmpty && self.segButtons != nil && !(self.segButtons?.isEmpty)! {
            let btnW = self.width/CGFloat(self.titles.count)
            for index in titles.indices {
                let segBtn = self.segButtons![index]
                segBtn.frame = CGRect(x: CGFloat(index) * btnW, y: 0, w: btnW, h: self.height)
            }
        }
    }
    
    @objc func didSelectedSegment(sender: UIButton) {
        if sender.isKind(of: UIButton.self) {
            let tag  = sender.tag
            for segBtn: UIButton in self.segButtons! {
                segBtn.isSelected = (segBtn.tag == tag) ? true : false
            }
            selIndex = tag
            self.delegate?.selectedSegmentContrlol(segment: self, index: selIndex)
        }
        
    }
}
