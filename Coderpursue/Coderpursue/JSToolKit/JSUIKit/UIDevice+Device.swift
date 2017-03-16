//
//  UIDevice+.swift
//  LoveYou
//
//  Created by WengHengcong on 2017/3/8.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

extension UIDevice {
    
    // MARK: - Device Series
    
    public enum Series: String {
        case iPhone
        case iPad
        case iPod
        case Simulator
        case Unknown
    }
    
    /// Device Serises
    static public func isPad() -> Bool {
        return series() == .iPad
    }
    
    static public func isPhone() -> Bool {
        return series() == .iPhone
        
    }
    
    static public func isPod() -> Bool {
        return series() == .iPod
    }
    
    static public func isSimulator() -> Bool {
        return series() == .Simulator
    }
    
    static fileprivate func getSeries(code: String) -> UIDevice.Series {
        let versionCode = model()
        
        switch versionCode {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3",
             "iPhone4,1", "iPhone4,2", "iPhone4,3",
             "iPhone5,1", "iPhone5,2",
             "iPhone5,3", "iPhone5,4",
             "iPhone6,1", "iPhone6,2",
             "iPhone7,2",
             "iPhone7,1",
             "iPhone8,1",
             "iPhone8,2",
             "iPhone8,4",
             "iPhone9,1", "iPhone9,3",
             "iPhone9,2", "iPhone9,4":                       return UIDevice.Series.iPhone
            
        case "iPad1,1",
             "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4",
             "iPad3,1", "iPad3,2", "iPad3,3",
             "iPad3,4", "iPad3,5", "iPad3,6",
             "iPad4,1", "iPad4,2", "iPad4,3",
             "iPad5,3", "iPad5,4",
             "iPad2,5", "iPad2,6", "iPad2,7",
             "iPad4,4", "iPad4,5", "iPad4,6",
             "iPad4,7", "iPad4,8", "iPad4,9",
             "iPad5,1", "iPad5,2",
             "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":     return UIDevice.Series.iPad
            
        case "iPod1,1",
             "iPod2,1",
             "iPod3,1",
             "iPod4,1",
             "iPod5,1",
             "iPod7,1":
            return UIDevice.Series.iPod
        case "i386", "x86_64":                          return UIDevice.Series.Simulator
        default:                                        return UIDevice.Series.Unknown
        }
    }
    
    static public func series() -> Series {
        let versionName = model()
        
        return getSeries(code: versionName)
    }
    
    
    // MARK: - Device Version
    
    public enum Version: String {
        /*** iPhone ***/
        case iPhone4
        case iPhone4S
        case iPhone5
        case iPhone5C
        case iPhone5S
        case iPhone6
        case iPhone6Plus
        case iPhone6S
        case iPhone6SPlus
        case iPhoneSE
        case iPhone7
        case iPhone7Plus
        
        /*** iPad ***/
        case iPad1
        case iPad2
        case iPadMini
        case iPad3
        case iPad4
        case iPadAir
        case iPadMini2
        case iPadAir2
        case iPadMini3
        case iPadMini4
        case iPadPro
        
        /*** iPod ***/
        case iPodTouch1Gen
        case iPodTouch2Gen
        case iPodTouch3Gen
        case iPodTouch4Gen
        case iPodTouch5Gen
        case iPodTouch6Gen
        
        /*** Simulator ***/
        case Simulator
        
        /*** Unknown ***/
        case Unknown
    }
    
    static let iPhone4Series:[Version]      = [.iPhone4,.iPhone4S]
    static let iPhone5Series:[Version]      = [.iPhone5,.iPhone5C,.iPhone5S]
    static let iPhone6Series:[Version]      = [.iPhone6,.iPhone6S]
    static let iPhone6PlusSeries:[Version]  = [.iPhone6Plus,.iPhone6SPlus]
    static let iPhoneSESeries:[Version]     = [.iPhoneSE]
    static let iPhone7Series:[Version]      = [.iPhone7]
    static let iPhone7PlusSeries:[Version]  = [.iPhone7Plus,]
    
    ///  Device Model
    static public func model() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    public static func modelReadable() -> Version {
        return getVersion(code: model())
    }
    
    static fileprivate func getVersion(code: String) -> Version {
        switch code {
            /*** iPhone ***/
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return  Version.iPhone4
        case "iPhone4,1", "iPhone4,2", "iPhone4,3":      return  Version.iPhone4S
        case "iPhone5,1", "iPhone5,2":                   return  Version.iPhone5
        case "iPhone5,3", "iPhone5,4":                   return  Version.iPhone5C
        case "iPhone6,1", "iPhone6,2":                   return  Version.iPhone5S
        case "iPhone7,2":                                return  Version.iPhone6
        case "iPhone7,1":                                return  Version.iPhone6Plus
        case "iPhone8,1":                                return  Version.iPhone6S
        case "iPhone8,2":                                return  Version.iPhone6SPlus
        case "iPhone8,4":                                return  Version.iPhoneSE
        case "iPhone9,1", "iPhone9,3":                   return  Version.iPhone7
        case "iPhone9,2", "iPhone9,4":                   return  Version.iPhone7Plus
            
            /*** iPad ***/
        case "iPad1,1":                                  return  Version.iPad1
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return  Version.iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":            return  Version.iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":            return  Version.iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":            return  Version.iPadAir
        case "iPad5,3", "iPad5,4":                       return  Version.iPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":            return  Version.iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":            return  Version.iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":            return  Version.iPadMini3
        case "iPad5,1", "iPad5,2":                       return  Version.iPadMini4
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return  Version.iPadPro
            
            /*** iPod ***/
        case "iPod1,1":                                  return  Version.iPodTouch1Gen
        case "iPod2,1":                                  return  Version.iPodTouch2Gen
        case "iPod3,1":                                  return  Version.iPodTouch3Gen
        case "iPod4,1":                                  return  Version.iPodTouch4Gen
        case "iPod5,1":                                  return  Version.iPodTouch5Gen
        case "iPod7,1":                                  return  Version.iPodTouch6Gen
            
            /*** Simulator ***/
        case "i386", "x86_64":                           return  Version.Simulator
            
        default:                                         return  Version.Unknown
        }
    }
    
    //MARK: - Other device information
    ///  Device name
    public static func name() -> String {
        return UIDevice.current.name
    }
    
    ///  Device language
    public static func language() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    
    ///  - UUID
    public static func uuid() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    ///   - Operating system name
    public static func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    public static func isPortrait() -> Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    public static func isLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
}

extension UIDevice {
    
    // MARK: - Device Version
    
    struct iOS {
        
        public enum Version: Float {
            case seven = 7.0
            case eight = 8.0
            case nine = 9.0
            case ten = 10.0
        }
        
        ///   - Operating system version
        public static func systemVersion() -> String {
            return UIDevice.current.systemVersion
        }
        
        ///   - Operating system version
        public static func systemFloatVersion() -> Float {
            return (systemVersion() as NSString).floatValue
        }
        
        public static func equal(_ version: Version) -> Bool {
            return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
        }
        
        public static func equalOrLater(_ version: Version) -> Bool {
            return systemFloatVersion() >= version.rawValue
        }
        
        public static func equalOrEarlier(_ version: Version) -> Bool {
            return systemFloatVersion() < (version.rawValue + 1.0)
        }
        
        public static var current: String {
            return "\(systemFloatVersion())"
        }
        
        ///
        static fileprivate func isSystemVersionOver(_ requiredVersion: String) -> Bool {
            switch systemVersion().compare(requiredVersion, options: NSString.CompareOptions.numeric) {
            case .orderedSame, .orderedDescending:
                //println("iOS >= 8.0")
                return true
            case .orderedAscending:
                //println("iOS < 8.0")
                return false
            }
        }
    }
    
    struct Battery {
        
        /**
         This enum describes the state of the battery.
         
         - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
         - Charging:  The device is plugged into power and the battery is less than 100% charged.
         - Unplugged: The device is not plugged into power; the battery is discharging.
         */
        public enum State: CustomStringConvertible, Equatable {
            /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
            case full
            /// The device is plugged into power and the battery is less than 100% charged.
            /// The associated value is in percent (0-100).
            case charging(Int)
            /// The device is not plugged into power; the battery is discharging.
            /// The associated value is in percent (0-100).
            case unplugged(Int)
            
            fileprivate init() {
                UIDevice.current.isBatteryMonitoringEnabled = true
                let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100))  // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
                // but maybe that changes in the future.
                switch UIDevice.current.batteryState {
                case .charging: self = .charging(batteryLevel)
                case .full:     self = .full
                case .unplugged:self = .unplugged(batteryLevel)
                case .unknown:  self = .full    // Should never happen since `batteryMonitoring` is enabled.
                }
                UIDevice.current.isBatteryMonitoringEnabled = false
            }
            
            public var description: String {
                switch self {
                case .charging(let batteryLevel):   return "Battery level: \(batteryLevel)%, device is plugged in."
                case .full:                         return "Battery level: 100 % (Full), device is plugged in."
                case .unplugged(let batteryLevel):  return "Battery level: \(batteryLevel)%, device is unplugged."
                }
            }
            
            static public func ==(lhs: State, rhs: State) -> Bool {
                return lhs.description == rhs.description
            }
            
            static public func <(lhs: State, rhs: State) -> Bool {
                switch (lhs, rhs) {
                case (.full, _):                                            return false                // return false (even if both are `.Full` -> they are equal)
                case (_, .full):                                            return true                 // lhs is *not* `.Full`, rhs is
                case (.charging(let lhsLevel), .charging(let rhsLevel)):    return lhsLevel < rhsLevel
                case (.charging(let lhsLevel), .unplugged(let rhsLevel)):   return lhsLevel < rhsLevel
                case (.unplugged(let lhsLevel), .charging(let rhsLevel)):   return lhsLevel < rhsLevel
                case (.unplugged(let lhsLevel), .unplugged(let rhsLevel)):  return lhsLevel < rhsLevel
                default:                                                    return false                // compiler won't compile without it, though it cannot happen
                }
            }
            
        }
        
        /// The state of the battery
        public var state: State {
            return State()
        }
        
        /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
        public var level: Int {
            switch State() {
            case .charging(let value):  return value
            case .full:                 return 100
            case .unplugged(let value): return value
            }
        }
    }
    
}
