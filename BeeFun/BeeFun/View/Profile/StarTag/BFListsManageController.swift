//
//  BFListsManageController.swift
//  BeeFun
//
//  Created by WengHengcong on 01/06/2017.
//  Copyright © 2017 JungleSong. All rights reserved.
//

import UIKit

class BFListsManageController: BFBaseViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists".localized
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
    
    
    // FIXME:
    override func reconnect() {
        super.reconnect()
    }
}
