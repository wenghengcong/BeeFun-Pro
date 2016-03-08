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
    
    var showcase:ObjTrendShowcase? {
        
        didSet {
            
            let urlPath:String = showcase!.imageUrl!
            
            let cache = KingfisherManager.sharedManager.cache
            
            //first:cache disk
            //if no disk cache,download image
            if let cacheImg = cache.retrieveImageInDiskCacheForKey(urlPath) {
                let colorImg:UIColor = UIColor(patternImage:cacheImg)
                self.bgImageV.backgroundColor = colorImg
            }else{
                
                let downloader = KingfisherManager.sharedManager.downloader
                
                downloader.downloadImageWithURL(NSURL(string: urlPath)!, options: [.Downloader(downloader)], progressBlock: { (receivedSize, totalSize) -> () in
                    
                    }) { (image, error, imageURL, originalData) -> () in
                        
                        if(image != nil){
                            cache.storeImage(image!, forKey: urlPath)
                            
                            let colorImg:UIColor = UIColor(patternImage:image!)
                            self.bgImageV.backgroundColor = colorImg
                            
                        }
                }
                
            }
            

            
            nameLabel.text = showcase!.name!
            descLabel.text = showcase!.cdescription
            
        }
        
    }


 
    override func customCellView() {
    
        self.bgImageV.backgroundColor = UIColor.clearColor()
        
        nameLabel.textColor = UIColor.whiteColor()
        
        descBgView.backgroundColor = UIColor.hexStr("#f7f7f7", alpha: 1.0)
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hexStr("#333333", alpha: 1.0)
        
        bottomLineV.backgroundColor = UIColor.lineBackgroundColor()

    }
}
