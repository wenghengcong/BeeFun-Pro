//
//  BFZipManager.swift
//  BeeFun
//
//  Created by WengHengcong on 2018/1/25.
//  Copyright © 2018年 LuCi. All rights reserved.
//

/*
import Zip

class BFZipManager: NSObject {
    
    static let shared = BFZipManager()
    
    func zipDB() -> Bool {
        do {
            if let needZipFile = BFPathManager.shared.needZipFilePath(), let zipFile = BFPathManager.shared.localZipFilePath() {
                try Zip.zipFiles(paths: [needZipFile], zipFilePath: zipFile, password: nil, compression: .BestCompression, progress: { (progress) in
                    print("zip file progress: \(progress)")
                })
                print("zip file path \(needZipFile)")
                return true
            }
        } catch {
            print("zip db file went wrong")
            SQLManager.checkDBValid()
        }
        return false
    }
    
    func unZipDB() -> Bool {
        do {
            if let unZipFile = BFPathManager.shared.localZipFilePath() ,let des = BFPathManager.shared.unZipFilePath() {
                try Zip.unzipFile(unZipFile, destination: des, overwrite: true, password: nil, progress: { (progress) -> () in
                    print("unzip file progress: \(progress)")
                })
                return true
            }
        } catch {
            print("unzip db file went wrong")
            //解压缩错误，就要检查是否有github.sqlite数据库，无就要创建
            SQLManager.checkDBValid()
        }
        return false
    }
    
}
 */
