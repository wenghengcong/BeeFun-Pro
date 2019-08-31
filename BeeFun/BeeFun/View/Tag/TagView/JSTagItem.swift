//
//  JSTagItem.swift
//  BeeFun
//
//  Created by WengHengcong on 14/05/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

protocol JSTagItemTouchProtocol: class {
    func touchTag(sender: JSTagItem, index: Int)
}

class JSTagItem: UIView {

    /// itme title
    var title: String? {
        didSet {
            setTitleAllState(title: title!)
        }
    }
    
    weak var delegate: JSTagItemTouchProtocol?
    
    var font: UIFont? = UIFont.bfSystemFont(ofSize: 15.0) {
        didSet {
            titleBtn.titleLabel?.font = font
        }
    }
    
    var align: NSTextAlignment? = .center {
        didSet {
            titleBtn.titleLabel?.textAlignment = align!
        }
    }
    
    var foreColor: UIColor? = .black {
        didSet {
            titleBtn.setTitleColor(foreColor, for: .normal)
        }
    }
    
    var backColor: UIColor? = .white {
        didSet {
            titleBtn.backgroundColor = backColor
        }
    }
    
    var attributeTitle: NSAttributedString? {
        didSet {
            titleBtn.titleLabel?.attributedText = attributeTitle
        }
    }
    
    var isSelected: Bool? = false {
        didSet {
            didSelectedTagButtion()
        }
    }
    
    var contentWidth: CGFloat {
        if self.title != nil {
            let width = self.title!.width(with: self.height, font: self.font!)
            return width+30
        }
        return 0
    }
    
    private lazy var titleBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String?) {
        assert(title != nil, "JSTagItem title can't nil")
        self.init(title: title, frame: CGRect.zero)
    }
    
    convenience init(title: String?, frame: CGRect) {
        assert(title != nil, "JSTagItem title can't nil")
        self.init(frame: frame)
        //初始化View
        commonInitView()
        //设置标题
        self.title = title
        setTitleAllState(title: title!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInitView() {
        setTitleColor(.black, for: .normal)
        setTitleColor(.bfRedColor, for: .highlighted)
        setTitleColor(.bfRedColor, for: .selected)
        titleBtn.addTarget(self, action: #selector(touchItem(sengder:)), for: .touchUpInside)
//        titleBtn.backgroundColor = UIColor.green
        self.addSubview(titleBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleBtn.frame = CGRect(x: 0, y: 0, w: self.contentWidth, h: self.height)
        self.frame = CGRect(x: self.x, y: self.y, w: self.contentWidth, h: self.height)
    }
    
    func didSelectedTagButtion() {
        if isSelected != nil {
            touchItem(sengder: titleBtn)
        }
    }
    
    func setTitle(_ title: String?, for state: UIControlState) {
        titleBtn.setTitle(title, for: state)
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        titleBtn.setTitleColor(color, for: state)
    }
    
    func setImage(_ image: UIImage?, for state: UIControlState) {
        titleBtn.setImage(image, for: state)
    }
    
    func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        titleBtn.setBackgroundImage(image, for: state)
    }
    
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        titleBtn.setAttributedTitle(title, for: state)
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        titleBtn.addTarget(target, action: action, for: controlEvents)
    }

    func setTitleAllState(title: String) {
        titleBtn.setTitle(title, for: .normal)
        titleBtn.setTitle(title, for: .highlighted)
        titleBtn.setTitle(title, for: .selected)
    }
    
    @objc func touchItem(sengder: UIButton) {
        if sengder.isKind(of: UIButton.self) {
            if sengder.isSelected {
                return
            } else {
                //选中
                sengder.isSelected = true
                self.delegate?.touchTag(sender: self, index: self.tag)
            }
        }
    }
    
    func setTagUnselected() {
        titleBtn.isSelected = false
    }
    
}
