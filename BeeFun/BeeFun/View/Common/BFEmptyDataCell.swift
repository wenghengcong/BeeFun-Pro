//
//  BFEmptyDataCell.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/6/2.
//  Copyright © 2018年 JungleSong. All rights reserved.
//

import UIKit

protocol BFEmptyDataCellDelegate: class {
    func didClickEmptyAction(cell: BFEmptyDataCell)
}

class BFEmptyDataCell: UITableViewCell, BFPlaceHolderViewDelegate {

    // 无数据提醒
    var tip: String?
    // 无数据提醒的图片
    var tipImage: String?
    // 无数据按钮的title
    var actionTitle: String?
    var placeEmptyView: BFPlaceHolderView?
    
    weak var delegate: BFEmptyDataCellDelegate?
    
    private let emptyViewTag: Int = 12353
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func display(tip: String?, imageName: String?, actionTitle: String?) {
        self.tip = tip
        self.tipImage = imageName
        self.actionTitle = actionTitle
        
        if self.tip == nil {
            self.tip = "Empty now"
        }
        if self.tipImage == nil {
            self.tipImage = "empty_data"
        }
        if self.actionTitle == nil {
            self.actionTitle = "Explore more".localized
        }
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        removeEmptyView()
        placeEmptyView = BFPlaceHolderView(frame: self.contentView.frame, tip: tip!, image: tipImage!, actionTitle: actionTitle!)
        placeEmptyView?.placeHolderActionDelegate = self
        contentView.addSubview(placeEmptyView!)
    }
    
    func removeEmptyView() {
        if let emptyView = placeEmptyView {
            emptyView.removeFromSuperview()
        }
    }
    
    func didAction(place: BFPlaceHolderView) {
        delegate?.didClickEmptyAction(cell: self)
    }
}
