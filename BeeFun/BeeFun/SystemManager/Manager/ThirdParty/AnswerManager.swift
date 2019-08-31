//
//  AnswerManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/4/13.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit
import Crashlytics

enum ContentViewType: String {
    case pv = "pv"      //用于页面willappear统计该页面的pv
    case uv = "uv"      //用于页面didload中统计该页面的uv
    case tm = "time"    //用于页面小时disappear中统计该页面的时长
    case web = "webview"    //用于统计网页
}

enum UserActionType: String {
    case follow
    case unfollow
    case star
    case unstar
    case fork
    case watch
    case unwatch
}

class AnswerManager: NSObject {

    /// 内容统计
    ///
    /// - Parameters:
    ///   - name: 名称
    ///   - type: 类型
    ///   - id: 唯一标识
    ///   - attributes: 自定义字段
    class func logContentView(name: String?, type: String?, id: String?, attributes: [String : Any]? = nil) {
        Answers.logContentView(withName: name, contentType: type, contentId: id, customAttributes: attributes)
    }

    /// 登录统计
    ///
    /// - Parameters:
    ///   - method: 登录方式：微信\QQ\FB\TW
    ///   - success: 登录结果
    ///   - attributes: 自定义字段
    class func logLogin(method: String?, success: NSNumber?, attributes: [String : Any]? = nil) {
        Answers.logLogin(withMethod: method, success: success, customAttributes: attributes)
    }

    /// 搜索统计
    ///
    /// - Parameters:
    ///   - query: 搜索字符串
    ///   - attributes: 自定义字段
    class func logSearch(query: String?, attributes: [String : Any]? = nil) {
        Answers.logSearch(withQuery: query, customAttributes: attributes)
    }

    /// 分享统计
    ///
    /// - Parameters:
    ///   - method: 分享途径
    ///   - name: 分享标题
    ///   - type: 分享类型：defalut、app、repository、user
    ///   - id: 分享唯一标识
    ///   - attributes: 自定义字段
    class func logShare(method: String?, name: String?, type: String?, id: String?, attributes: [String : Any]? = nil) {
        Answers.logShare(withMethod: method, contentName: name, contentType: type, contentId: id, customAttributes: attributes)
    }

}
