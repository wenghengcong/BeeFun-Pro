//
//  SESearchOrderButton.swift
//  BeeFun
//
//  Created by WengHengcong on 07/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

/// order按钮的选中状态
///
/// - none: 未选中
/// - up: 选中上面按钮
/// - down: 选中下面按钮
enum SESearchOrderButtonState: Int {
    case none
    case up
    case down
}

class SESearchOrderButton: UIControl {
    
    var titleLabel = UILabel()
    var upImageView = UIImageView(image:UIImage(named: "se_up_triangle"))
    var downImageView = UIImageView(image:UIImage(named: "se_down_triangle"))
    
    var title: String? {
        didSet {
            titleLabel.text = title
            setNeedsLayout()
        }
    }
    var selState: SESearchOrderButtonState = .none {
        didSet {
            sob_setState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, frame: CGRect) {
        self.init(frame: frame)
        self.title = title
        sob_setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetState() {
        selState = .none
        setNeedsLayout()
    }
    
    func sob_setupView() {
//        backgroundColor = UIColor.green
        if title == nil {
            title = ""
        }
        titleLabel.text = self.title
        titleLabel.textAlignment = .right
        titleLabel.adjustFontSizeToFitWidth(minScale: 0.5)
        titleLabel.font = UIFont.middleSizeSystemFont()
        addSubview(titleLabel)
        addSubview(upImageView)
        addSubview(downImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfHeight = self.height
        var titleW = self.title!.width(with: selfHeight, font: UIFont.middleSizeSystemFont())
        if titleW < 5.0 {
            titleW += 2.0
        }
        let imgW: CGFloat = 12.0
        upImageView.frame = CGRect(x: self.width-imgW-2.0, y: 10, w: imgW, h: imgW)
        downImageView.frame = CGRect(x: upImageView.left, y: upImageView.bottom-4, w: imgW, h: imgW)
        titleLabel.frame = CGRect(x: upImageView.left-titleW-2.0, y: 0, w: titleW, h: selfHeight)
    }
    
    func sob_setState() {
        var upImgageName = "se_up_triangle"
        var downImgageName = "se_down_triangle"
        switch selState {
        case .none:
            upImgageName = "se_up_triangle"
            downImgageName = "se_down_triangle"
        case .up:
            upImgageName = "se_up_triangle_sel"
            downImgageName = "se_down_triangle"
        case .down:
            upImgageName = "se_up_triangle"
            downImgageName = "se_down_triangle_sel"
        }
        
        upImageView.image =  UIImage(named: upImgageName)
        downImageView.image = UIImage(named: downImgageName)
        setNeedsLayout()
    }
    
}
