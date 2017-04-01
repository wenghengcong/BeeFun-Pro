//
//  JSCommentStyleGudie.swift
//  LoveYou
//
//  Created by WengHengcong on 2016/10/20.
//  Copyright © 2016年 JungleSong. All rights reserved.
//

//以下是为了测试注释
//参考：http://nshipster.cn/swift-documentation/
import Foundation

/// 🚲 一个两轮的，人力驱动的交通工具.
class Bicycle {
    /**
     车架样式.
     
     - Road: 用于街道或步道.
     - Touring: 用于长途.
     - Cruiser: 用于城镇周围的休闲之旅.
     - Hybrid: 用于通用运输.
     */
    enum Style {
        case Road, Touring, Cruiser, Hybrid
    }
    
    /**
     转换踏板功率为运动的机制。
     
     - Fixed: 一个单一的，固定的齿轮。
     - Freewheel: 一个可变速，脱开的齿轮。
     */
    enum Gearing {
        case Fixed
        case Freewheel(speeds: Int)
    }
    
    /**
     用于转向的硬件。
     
     - Riser: 一个休闲车把。
     - Café: 一个正常车把。
     - Drop: 一个经典车把.
     - Bullhorn: 一个超帅车把.
     */
    enum Handlebar {
        case Riser, Café, Drop, Bullhorn
    }
    
    enum kjkj {
        case ik
    }
    /// 自行车的风格
    let style: Style
    
    /// 自行车的齿轮
    let gearing: Gearing
    
    /// 自行车的车把
    let handlebar: Handlebar
    
    /// 车架大小, 厘米为单位.
    let frameSize: Int
    
    /// 自行车行驶的旅程数
    private(set) var numberOfTrips: Int
    
    /// 自行车总共行驶的距离，米为单位
    private(set) var distanceTravelled: Double
    
    /**
     使用提供的部件及规格初始化一个新自行车。
     
     :param: style 自行车的风格
     :param: gearing 自行车的齿轮
     :param: handlebar 自行车的车把
     :param: centimeters 自行车的车架大小，单位为厘米
     
     :returns: 一个漂亮的，全新的，为你度身定做.
     */
    init(style: Style, gearing: Gearing, handlebar: Handlebar, frameSize centimeters: Int) {
        self.style = style
        self.gearing = gearing
        self.handlebar = handlebar
        self.frameSize = centimeters
        
        self.numberOfTrips = 0
        self.distanceTravelled = 0
    }
    
    /**
     把自行车骑出去遛一圈
     
     :param: meters 行驶的距离，单位为米
     */
    func travel(distance meters: Double) {
        if meters > 0 {
            distanceTravelled += meters
            numberOfTrips+=1
        }
    }
}



// MARK: Printable

extension Bicycle {
    var description: String {
        var descriptors: [String] = []
        
        switch self.style {
        case .Road:
            descriptors.append("A road bike for streets or trails")
        case .Touring:
            descriptors.append("A touring bike for long journeys")
        case .Cruiser:
            descriptors.append("A cruiser bike for casual trips around town")
        case .Hybrid:
            descriptors.append("A hybrid bike for general-purpose transportation")
        }
        
        switch self.gearing {
        case .Fixed:
            descriptors.append("with a single, fixed gear")
        case .Freewheel(let n):
            descriptors.append("with a \(n)-speed freewheel gear")
        }
        
        switch self.handlebar {
        case .Riser:
            descriptors.append("and casual, riser handlebars")
        case .Café:
            descriptors.append("and upright, café handlebars")
        case .Drop:
            descriptors.append("and classic, drop handlebars")
        case .Bullhorn:
            descriptors.append("and powerful bullhorn handlebars")
        }
        
        descriptors.append("on a \(frameSize)\" frame")
        
// FIXME:
        
        // FIXME: 使用格式化的距离
        descriptors.append("with a total of \(distanceTravelled) meters traveled over \(numberOfTrips) trips.")
// TODO:
        
// DEBUG:

        // TODO: 允许自行车被命名吗？
        
        return descriptors[0]
    }
}

