//
//  CPTrendingShowcaseCell.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/8/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import Kingfisher

class CPTrendingShowcaseCell: CPBaseViewCell {
    
    @IBOutlet weak var bgImageV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descBgView: UIView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var bottomLineV: UIView!
    
    var showcase:ObjShowcase? {
        
        didSet {
            
            let urlPath:String = showcase!.image_url!
            
            let cache = KingfisherManager.shared.cache
            
            //first:cache disk
            //if no disk cache,download image
            if let cacheImg = cache.retrieveImageInDiskCache(forKey: urlPath){
                let colorImg:UIColor = UIColor(patternImage:cacheImg)
                self.bgImageV.backgroundColor = colorImg
            }else{
                
                let downloader = KingfisherManager.shared.downloader
                downloader.downloadImage(with: URL(string: urlPath)!, options: [.downloader(downloader)], progressBlock: { (receivedSize, totalSize) in
                    
                    }, completionHandler: { (image, error, imageURL, originalData) -> () in
                        
                        if(image != nil){
                            cache.store(image!, forKey: urlPath)
                            let colorImg:UIColor = UIColor(patternImage:image!)
                            self.bgImageV.backgroundColor = colorImg
                            
                        }
                    }
                )
                
                nameLabel.text = showcase!.name!
                descLabel.text = showcase!.cdescription
            
            }
        
        }

    }
 
    override func customCellView() {
    
        self.bgImageV.backgroundColor = UIColor.clear
        
        nameLabel.textColor = UIColor.white
        
        descBgView.backgroundColor = UIColor.hex("#f7f7f7", alpha: 1.0)
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("#333333", alpha: 1.0)
        
        bottomLineV.backgroundColor = UIColor.lineBackgroundColor()

    }
}
