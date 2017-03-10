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
    
    
    /// view
    func riv_customView() {
        
        self.backgroundColor = UIColor.white
        let widthBy3Part = UIScreen.width/3
        let widthBy2Part = UIScreen.width/2
        let lineH = designBy4_7Inch(30.0)
        
        let imgEdgeInsets1 = UIEdgeInsetsMake(0, 0, 0, 10)
        let borderWidth:CGFloat = 0.5
        
        let btnArr1:[UIButton] = [watchBtn,starBtn,forkBtn]
        let line1Y:CGFloat = 0.0

        for (index,btn) in btnArr1.enumerated() {
            let x = CGFloat(index) * widthBy3Part
            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(line1Y)
                make.leading.equalTo(x)
                make.width.equalTo(widthBy3Part)
                make.height.equalTo(lineH)
            })
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets1
            btn.layer.borderColor = UIColor.lineBackgroundColor().cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), for: UIControlState())
//            btn .addTarget(self, action: #selctor(), for: .touchUpInside)
        }
        
        let imgEdgeInsets2 = UIEdgeInsetsMake(0, -40, 0, 10)
        let btnArr2:[UIButton] = [lanBtn,privateBtn,issueBtn,filesizeBtn]
        
        for (index,btn) in btnArr2.enumerated() {
            
            let x = CGFloat(index%2) * widthBy2Part
            let y = (index < 2) ? lineH : (2*lineH)

            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(y)
                make.leading.equalTo(x)
                make.width.equalTo(widthBy2Part)
                make.height.equalTo(lineH)
            })
            btn.imageView?.contentMode = .scaleAspectFit
            btn.imageEdgeInsets = imgEdgeInsets2
            btn.layer.borderColor = UIColor.lineBackgroundColor().cgColor
            btn.layer.borderWidth = borderWidth
            btn.setTitleColor(UIColor.labelTitleTextColor(), for: UIControlState())
        }
        
        watchBtn.setImage(UIImage(named: "octicon_watch_20"), for: UIControlState())
        starBtn.setImage(UIImage(named: "octicon_star_20"), for: UIControlState())
        forkBtn.setImage(UIImage(named: "octicon_fork_20"), for: UIControlState())
        
        lanBtn.setImage(UIImage(named: "octicon_language_20"), for: UIControlState())
        privateBtn.setImage(UIImage(named: "octicon_private_20"), for: UIControlState())
        issueBtn.setImage(UIImage(named: "octicon_issue_20"), for: UIControlState())
        filesizeBtn.setImage(UIImage(named: "octicon_filesize_20"), for: UIControlState())
    
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - data
    func riv_fillData() {
        
        riv_customView()
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

        self.setNeedsLayout()
        
    }

    func jumpWebView() {
        
    }
    
}
