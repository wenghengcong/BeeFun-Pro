//
//  InfoButton.swift
//  Coderpursue
//
//  Created by WengHengcong on 2017/3/10.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

class ObjInfo: NSObject {
    var image:String?
    var title:String?
    var url:String?
    
    init(image:String? ,title:String? ,url:String?) {
        self.image = image
        self.title = title
        self.url = url
    }
}

class InfoButton: UIButton {
    
    var imageV:UIImageView?
    var titleL:UILabel?
    var url:String?
    var objInfo:ObjInfo? {
        didSet {
            ib_fillData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(image:String? ,title:String? ,url:String?) {
        super.init(frame:CGRect.zero)
        self.objInfo = ObjInfo.init(image:image,title:title,url:url)
    }
    
    convenience init(info:ObjInfo) {
        self.init(image:info.image ,title:info.title,url:info.url)
        self.objInfo = info
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func ib_customView() {
        if imageV == nil {
            imageV = UIImageView.init()
            imageV?.backgroundColor = UIColor.red
            self.addSubview(imageV!)
        }
        
        if titleL == nil{
            titleL = UILabel.init()
            titleL?.backgroundColor = UIColor.green
            self.addSubview(titleL!)
        }

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if imageV != nil {
            let imgw:CGFloat = 20
            let imgx = self.width * 0.2
            let imgy = (self.height - imgw)/2
            
            imageV?.snp.makeConstraints({ (make) in
                make.top.equalTo(imgy)
                make.leading.equalTo(imgx)
                make.width.equalTo(imgw)
                make.height.equalTo(imgw)
            })
        }

        if titleL != nil {
            let titx = (imageV?.right)! + 10
            let tity = 0
            let tith = self.height
            
            titleL?.snp.makeConstraints({ (make) in
                make.top.equalTo(tity)
                make.leading.equalTo(titx)
                make.trailing.equalTo(0)
                make.height.equalTo(tith)
            })
        }
    
    }
    
    func ib_fillData() {
        ib_customView()
        if let image = objInfo?.image {
            imageV?.image = UIImage.init(named: image)

        }
        if let title = objInfo?.title {
            titleL?.text = title
        }

        if let url = objInfo?.url {
            self.url = url
        }
        self.setNeedsLayout()

    }
    
}
