//
//  BFReposSyncController.swift
//  BeeFun
//
//  Created by WengHengcong on 18/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFReposSyncController: BFBaseViewController {

    var tipLabel = UILabel()
    var syncButton: UIButton = UIButton()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        rsc_viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func leftItemAction(_ sender: UIButton?) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func rsc_viewInit() {
        title = "Sync".localized
        
        refreshHidden = .all
        view.addSubview(tableView)
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
    
        let tips = "Immediately sync your star repositories from github.com in silence.".localized
        let tipFont = UIFont.bfSystemFont(ofSize: 18.0)
        tipLabel.font = tipFont
        tipLabel.text = tips
        tipLabel.numberOfLines = 0
        
        let lblX: CGFloat = 20
        let lblW = ScreenSize.width-lblX
        let height = tips.height(with: ScreenSize.width-10, font: tipFont) + 10
        tipLabel.textColor = UIColor.black
        tipLabel.frame = CGRect(x: lblX, y: 120, w: lblW, h: height)
        view.addSubview(tipLabel)
        
        syncButton.setTitle("Sync".localized, for: .normal)
        syncButton.setTitle("Sync".localized, for: .highlighted)
        syncButton.setTitleColor(UIColor.white, for: .normal)
        syncButton.setTitleColor(UIColor.white, for: .highlighted)
        syncButton.titleLabel?.font = UIFont.bfSystemFont(ofSize: 20.0)
        syncButton.backgroundColor = UIColor.bfRedColor
        syncButton.radius = 5.0
        syncButton.addTarget(self, action: #selector(BFReposSyncController.rsc_syncAction), for: UIControlEvents.touchUpInside)
        view.addSubview(syncButton)
        
        let logX: CGFloat = 10
        let logW = ScreenSize.width-2*logX
        let logH: CGFloat = 50
        let logY = ScreenSize.height-uiTopBarHeight - 40
        syncButton.frame = CGRect(x: logX, y: logY, w: logW, h: logH)
    }
    
    @objc func rsc_syncAction() {
        BeeFunDBManager.shared.updateServerDB(showTips: true, first: false)
    }
}
