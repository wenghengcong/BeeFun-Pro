//
//  BFEventCellImageViewAttachment.swift
//  BeeFun
//
//  Created by WengHengcong on 22/09/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit
import YYText

class BFImageViewAttachment: YYTextAttachment {
    
    var imageURL: URL?
    var size: CGSize?
    
    private var _imageView: UIImageView?
    
    override var content: Any? {
        set {
            _imageView = content as? UIImageView
        }
        get {
           /// UIImageView 只能在主线程访问
            if pthread_main_np() == 0 {
                return nil
            }
            if _imageView != nil {
                return _imageView
            }
            /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
            /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
            _imageView = UIImageView()
            _imageView?.size = size ?? CGSize.zero
            _imageView?.kf.setImage(with: imageURL)
            return _imageView
        }
    }
    
}
