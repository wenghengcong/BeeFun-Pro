//
//  BFBaseViewController+Answer.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/16.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension BFBaseViewController {

    func gatherUserActivityInViewDidload() {
        let methodStr = #function
        AnswerManager.logContentView(name: self.title?.enLocalized ?? "Unkonwn", type: ContentViewType.uv.rawValue, id: self.className, attributes: ["method": methodStr])
    }

    func gatherUserActivityInViewWillAppear() {
        let methodStr = #function
        AnswerManager.logContentView(name: self.title?.enLocalized ?? "Unkonwn", type: ContentViewType.pv.rawValue, id: self.className, attributes: ["method": methodStr])
    }

    func gatherUserActivityInViewWillDisAppear() {
        let methodStr = #function
        AnswerManager.logContentView(name: self.title?.enLocalized ?? "Unkonwn", type: ContentViewType.tm.rawValue, id: self.className, attributes: ["method": methodStr])
    }

}
