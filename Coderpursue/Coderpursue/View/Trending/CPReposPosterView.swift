//
//  CPReposPosterView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit
import SwiftDate


protocol ReposActionProtocol {
    
    func watchReposAction()
    func starReposAction()
    func forkReposAction()
    
}

/// Repos 头部的代码库的主要信息视图
class CPReposPosterView: UIView {

    @IBOutlet weak var imgV: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var forkBtn: UIButton!

    var reposActionDelegate:ReposActionProtocol?
    
    var repo:ObjRepos? {
        didSet{
            rpc_fillData()
        }
    }
    
    var watched:Bool?{
        didSet{
            if(watched!){
                watchBtn.setTitle("Unwatch", for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)

            }else{
                watchBtn.setTitle("Watch", for: UIControlState())
                watchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)

            }
        }
    }
    
    var stared:Bool?{
        didSet{
            if(stared!){
                starBtn.setTitle("Unstar", for: UIControlState())
            }else{
                starBtn.setTitle("Star", for: UIControlState())
            }
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        rpv_customView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(obj:ObjRepos){
        super.init(frame:CGRect.zero)
        self.repo = obj
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }


    // MARK: - View
    func rpv_customView() {
        
        nameLabel.textColor = UIColor.labelTitleTextColor()
        descLabel.textColor = UIColor.labelSubtitleTextColor()
        descLabel.numberOfLines = 3;
        timeLabel.textColor = UIColor.hex("#4876FF")
        
        /// Test
//        nameLabel.backgroundColor = UIColor.red
//        descLabel.backgroundColor = UIColor.blue
//        timeLabel.backgroundColor = UIColor.green
        
        let imgEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 10)
        let cornerRadius:CGFloat = 5.0
        let borderWidth:CGFloat = 0.5
        
        let btnArr = [watchBtn,starBtn,forkBtn]
        
        for btn in btnArr {
            
            btn?.imageView?.contentMode = .scaleAspectFit
            btn?.imageEdgeInsets = imgEdgeInsets
            btn?.layer.cornerRadius = cornerRadius
            btn?.layer.masksToBounds = true
            btn?.layer.borderColor = UIColor.cpRedColor().cgColor
            btn?.layer.borderWidth = borderWidth
            btn?.setTitleColor(UIColor.cpRedColor(), for: UIControlState())
            
        }
        watchBtn.setImage(UIImage(named: "octicon_watch_red_20"), for: UIControlState())
        watchBtn.setTitle("Watch", for: UIControlState())
        watchBtn.addTarget(self, action: #selector(CPReposPosterView.rpc_watchAction), for: .touchUpInside)

        starBtn.setImage(UIImage(named: "octicon_star_red_20"), for: UIControlState())
        starBtn.setTitle("Star", for: UIControlState())
        starBtn.addTarget(self, action: #selector(CPReposPosterView.rpc_starAction), for: .touchUpInside)

        forkBtn.setImage(UIImage(named: "octicon_fork_red_20"), for: UIControlState())
        forkBtn.setTitle("Fork", for: UIControlState())
        forkBtn.addTarget(self, action: #selector(CPReposPosterView.rpc_forkAction), for: .touchUpInside)

    }
    
    override func layoutSubviews() {
        
        let margin:CGFloat = 10.0

        imgV.snp.remakeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalTo(margin+7.0)
            make.left.equalTo(margin)
        }
        
        let nameL = imgV.right+10
        let nameT = 10
        let nameH = 24
        
        nameLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(nameT)
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.height.equalTo(nameH)
        }
        
        let descT = nameLabel.bottom+2.0
        var descH = descLabel.requiredHeight(width:nameLabel.width)
        if descH > 47.0 {
            descH = 47.0
        }
        
        descLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.top.equalTo(descT)
            make.height.equalTo(descH)
        }
        
        let timeT = imgV.bottom-16
        timeLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(nameL)
            make.trailing.equalTo(-margin)
            make.top.equalTo(timeT)
            make.height.equalTo(21)
        }
        
        
        let top:CGFloat = max(imgV.bottom, timeLabel.bottom)+10.0
        let width = (ScreenSize.width-4*margin)/3;
        let height:CGFloat = 30.0
        
        let btnArr = [watchBtn,starBtn,forkBtn]
        
        for (index,button) in btnArr.enumerated() {
            let left = CGFloat.init(index) * (width+margin) + margin
            button?.snp.remakeConstraints({ (make) in
                make.left.equalTo(left)
                make.top.equalTo(top)
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
        }

        let selfH = watchBtn.bottom + 10
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(64)
            make.height.equalTo(selfH)
        }
    }
    
    // MARK: - Data
    func rpc_fillData() {
        
        if let avatarUrl =  repo?.owner?.avatar_url {
            imgV.kf.setImage(with: URL(string: avatarUrl)!)
        }
        
        if let username = repo!.name {
            nameLabel.text = username
        }
        
        if let cdescription = repo!.cdescription {
            descLabel.text = cdescription
        }
        
        if let created_at = repo!.created_at {
            timeLabel.text = TimeHelper.shared.readableTime(rare: created_at, prefix: "created at: ")
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: - Action
    func rpc_watchAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.watchReposAction()
        }
        
    }
    
    func rpc_starAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.starReposAction()
        }
        
    }
    
    func rpc_forkAction() {
        if( self.reposActionDelegate != nil ){
            self.reposActionDelegate!.forkReposAction()
        }
        
    }
    

}
