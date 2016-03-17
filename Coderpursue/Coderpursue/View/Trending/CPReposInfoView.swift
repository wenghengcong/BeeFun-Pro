//
//  CPReposInfoView.swift
//  Coderpursue
//
//  Created by WengHengcong on 3/9/16.
//  Copyright © 2016 JungleSong. All rights reserved.
//

import UIKit

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
        super.init(frame:CGRectZero)
        self.repo = obj
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func riv_customView() {
        
        self.backgroundColor = UIColor.hexStr("#e8e8e8", alpha: 1.0)
        
        let imgEdgeInsets1 = UIEdgeInsetsMake(0, 0, 0, 10)
        let borderWidth:CGFloat = 0.5
        
        let btnArr1:[UIButton] = [watchBtn,starBtn,forkBtn]
        
        for btn in btnArr1 {
            btn.imageView?.contentMode = .ScaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.lineBackgroundColor().CGColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), forState: .Normal)
        }
        
        watchBtn.setImage(UIImage(named: "octicon_watch_20"), forState: .Normal)
        watchBtn.setTitle("0", forState: .Normal)
        
        starBtn.setImage(UIImage(named: "octicon_star_20"), forState: .Normal)
        starBtn.setTitle("0", forState: .Normal)

        forkBtn.setImage(UIImage(named: "octicon_fork_20"), forState: .Normal)
        forkBtn.setTitle("0", forState: .Normal)
        
        let imgEdgeInsets2 = UIEdgeInsetsMake(0, -40, 0, 10)
        let btnArr2:[UIButton] = [lanBtn,privateBtn,issueBtn,filesizeBtn]
        
        for btn in btnArr2 {
            btn.imageView?.contentMode = .ScaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets2
            btn.layer.borderColor = UIColor.lineBackgroundColor().CGColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), forState: .Normal)
        }
        
        lanBtn.setImage(UIImage(named: "octicon_language_20"), forState: .Normal)
        lanBtn.setTitle("Swift", forState: .Normal)
        
        privateBtn.setImage(UIImage(named: "octicon_private_20"), forState: .Normal)
        privateBtn.setTitle("Public", forState: .Normal)
        
        issueBtn.setImage(UIImage(named: "octicon_issue_20"), forState: .Normal)
        issueBtn.setTitle("0 issue", forState: .Normal)
        
        filesizeBtn.setImage(UIImage(named: "octicon_filesize_20"), forState: .Normal)
        filesizeBtn.setTitle("1 MB", forState: .Normal)
        
    }
    
    
    func riv_fillData() {
        
        if let watchCount = repo?.subscribers_count {
            watchBtn.setTitle("\(watchCount)", forState: .Normal)
        }
        
        if let stargazersCount = repo?.stargazers_count {
            starBtn.setTitle("\(stargazersCount)", forState: .Normal)
        }
        
        if let forksCount = repo?.forks_count {
            forkBtn.setTitle("\(forksCount)", forState: .Normal)
        }
        
        
        if let lan = repo?.language {
            lanBtn.setTitle("\(lan)", forState: .Normal)
        }
        
        
        if let cprivate = repo?.cprivate {
            if(cprivate){
                privateBtn.setTitle("Private", forState: .Normal)
            }else{
                privateBtn.setTitle("Public", forState: .Normal)
            }
        }
        
        if let issueCount = repo?.open_issues_count {
            if(issueCount <= 1){
                issueBtn.setTitle("\(issueCount) issue", forState: .Normal)
            }else{
                issueBtn.setTitle("\(issueCount) issues", forState: .Normal)
            }
        }
        if let fileMB = repo?.size {
            
            let fileMB = String(format: "%.2f", ((Double)(fileMB)/1024.0) )
            filesizeBtn.setTitle("\(fileMB) MB", forState: .Normal)
            
        }

        
    }


}
