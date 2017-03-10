//
//  CPReposInfoView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

/// Repos 底部的代码库的详细信息视图
class CPReposInfoView: UIView {

    @IBOutlet weak var watchBtn: UIButton!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var forkBtn: UIButton!

    @IBOutlet weak var lanBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    @IBOutlet weak var issueBtn: UIButton!
    @IBOutlet weak var filesizeBtn: UIButton!
    
    var repo:ObjRepos? {
        didSet{
            riv_fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        riv_customView()
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
    
    
    func riv_customView() {
        
        self.backgroundColor = UIColor.hex("#e8e8e8", alpha: 1.0)
        
        let imgEdgeInsets1 = UIEdgeInsetsMake(0, 0, 0, 10)
        let borderWidth:CGFloat = 0.5
        
        let btnArr1:[UIButton] = [watchBtn,starBtn,forkBtn]
        
        for btn in btnArr1 {
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.lineBackgroundColor().cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), for: UIControlState())
        }
        
        watchBtn.setImage(UIImage(named: "octicon_watch_20"), for: UIControlState())
        watchBtn.setTitle("0", for: UIControlState())
        
        starBtn.setImage(UIImage(named: "octicon_star_20"), for: UIControlState())
        starBtn.setTitle("0", for: UIControlState())

        forkBtn.setImage(UIImage(named: "octicon_fork_20"), for: UIControlState())
        forkBtn.setTitle("0", for: UIControlState())
        
        let imgEdgeInsets2 = UIEdgeInsetsMake(0, -40, 0, 10)
        let btnArr2:[UIButton] = [lanBtn,privateBtn,issueBtn,filesizeBtn]
        
        for btn in btnArr2 {
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets2
            btn.layer.borderColor = UIColor.lineBackgroundColor().cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), for: UIControlState())
        }
        
        lanBtn.setImage(UIImage(named: "octicon_language_20"), for: UIControlState())
        lanBtn.setTitle("Swift", for: UIControlState())
        
        privateBtn.setImage(UIImage(named: "octicon_private_20"), for: UIControlState())
        privateBtn.setTitle("Public", for: UIControlState())
        
        issueBtn.setImage(UIImage(named: "octicon_issue_20"), for: UIControlState())
        issueBtn.setTitle("0 issue", for: UIControlState())
        
        filesizeBtn.setImage(UIImage(named: "octicon_filesize_20"), for: UIControlState())
        filesizeBtn.setTitle("1 MB", for: UIControlState())
        
    }
    
    
    func riv_fillData() {
        
        if let watchCount = repo?.subscribers_count {
            watchBtn.setTitle("\(watchCount)", for: UIControlState())
        }
        
        if let stargazersCount = repo?.stargazers_count {
            starBtn.setTitle("\(stargazersCount)", for: UIControlState())
        }
        
        if let forksCount = repo?.forks_count {
            forkBtn.setTitle("\(forksCount)", for: UIControlState())
        }
        
        
        if let lan = repo?.language {
            lanBtn.setTitle("\(lan)", for: UIControlState())
        }
        
        
        if let cprivate = repo?.cprivate {
            if(cprivate){
                privateBtn.setTitle("Private", for: UIControlState())
            }else{
                privateBtn.setTitle("Public", for: UIControlState())
            }
        }
        
        if let issueCount = repo?.open_issues_count {
            if(issueCount <= 1){
                issueBtn.setTitle("\(issueCount) issue", for: UIControlState())
            }else{
                issueBtn.setTitle("\(issueCount) issues", for: UIControlState())
            }
        }
        if let fileMB = repo?.size {
            
            let fileMB = String(format: "%.2f", ((Double)(fileMB)/1024.0) )
            filesizeBtn.setTitle("\(fileMB) MB", for: UIControlState())
            
        }

        
    }


}
