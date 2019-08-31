//
//  BFPlaceHolderView.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/2.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

protocol BFPlaceHolderViewDelegate: class {
    func didAction(place: BFPlaceHolderView)
}

/// 占位视图
class BFPlaceHolderView: UIView {

    /// 提示字符串
    var tip: String?
    /// 提示图
    var image: String?
    /// 操作按钮标题
    var actionTitle: String?
    /// 要执行的动作
    
    weak var placeHolderActionDelegate: BFPlaceHolderViewDelegate?
    
    private var tipLabel = UILabel()
    private var tipImageView = UIImageView()
    private var actionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        bfphv_custom()
    }
    convenience init(tip: String?, image: String?, actionTitle: String?) {
        self.init(frame: CGRect.zero, tip: tip, image: image, actionTitle: actionTitle)
    }
    
    convenience init(frame: CGRect, tip: String?, image: String?, actionTitle: String?) {
        self.init(frame: frame)
        self.tip = tip
        self.image = image
        self.actionTitle = actionTitle
//        windowLevel = .greatestFiniteMagnitude
        bfphv_custom()
    }
    
    private func bfphv_custom() {
        backgroundColor = UIColor.white
        
        addSubview(tipImageView)
        tipLabel.font = UIFont.bfSystemFont(ofSize: 19.0)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        tipLabel.textColor = UIColor.iOS11Gray
        addSubview(tipLabel)

        actionButton.addBorderAround(UIColor.bfRedColor, radius: 2.0, width: 1.0)
        actionButton.setTitleColor(UIColor.bfRedColor, for: .normal)
        actionButton.setTitleColor(UIColor.bfRedColor, for: .highlighted)
        actionButton.titleLabel?.textAlignment = .center
        actionButton.titleLabel?.font = UIFont.bfSystemFont(ofSize: 18.0)
        actionButton.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        addSubview(actionButton)
        
        fillDataToUI()
    }
    
    @objc func buttonAction() {
        print("reload action tapped")
        DispatchQueue.main.async {
            self.placeHolderActionDelegate?.didAction(place: self)
        }
    }
    
    // MARK: - 数据
    /// 刷新数据到页面
    func fillDataToUI() {
        
        if let imageName = image, let uiimageObj = UIImage(named: imageName) {
            tipImageView.image = uiimageObj
        }
        
        if let tipString = tip {
            tipLabel.text = tipString
        }

        if let buttonTitle = actionTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
        }
        setNeedsDisplay()
    }
    
    /// 重新布局
    override func layoutSubviews() {
        assert(tipImageView.image != nil)
        let uiimageObj = tipImageView.image!
        let imageW: CGFloat = uiimageObj.size.width
        let imageX: CGFloat = (self.width-imageW)/2
        let imageH: CGFloat = uiimageObj.size.height
        tipImageView.frame = CGRect(x: imageX, y: 100, w: imageW, h: imageH)

        let imageToLabelMargin: CGFloat = 13
    
        let tipLabelX: CGFloat = 40
        let tipLabelW = self.width-2*tipLabelX
        let tipLabelH = BFGlobalHelper.heightWithConstrainedWidth(tipLabel.text ?? "", width: tipLabelW, font: tipLabel.font)
        
        let labelToButtonMargin: CGFloat = 15
        let btnH: CGFloat = 40
        let btnW: CGFloat = BFGlobalHelper.widthWithConstrainedHeight(actionButton.currentTitle ?? "", height: btnH, font: actionButton.titleLabel!.font) + 20
        let btnX = (self.width-btnW)/2
        
        let allH = imageH + imageToLabelMargin + tipLabelH + labelToButtonMargin + btnH
        let allY = (self.height-allH)/2-20
        tipImageView.frame = CGRect(x: imageX, y: allY, w: imageW, h: imageH)

        let tipLabelY = tipImageView.bottom + imageToLabelMargin
        tipLabel.frame = CGRect(x: tipLabelX, y: tipLabelY, w: tipLabelW, h: tipLabelH)

        let btnY: CGFloat = tipLabel.bottom + labelToButtonMargin
        actionButton.frame = CGRect(x: btnX, y: btnY, w: btnW, h: btnH)
    }
    
    // MARK: - 重绘页面
    func refresh() {
        setNeedsDisplay()
    }
    
    func refresh(tip: String?) {
        refresh(tip: tip, image: nil, actionTitle: nil)
    }
    
    func refresh(image: String?) {
        refresh(tip: nil, image: image, actionTitle: nil)
    }
    
    func refresh(actionTitle: String?) {
        refresh(tip: nil, image: nil, actionTitle: actionTitle)
    }
    
    func refresh(tip: String?, image: String?, actionTitle: String?) {
        if tip != nil {
            self.tip = tip
        }
        if image != nil {
            self.image = image
        }
        if actionTitle != nil {
            self.actionTitle = actionTitle
        }
        fillDataToUI()
    }

}
