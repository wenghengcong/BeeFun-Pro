//
//  UIImage+Extension.swift
//  BeeFun
//
//  Created by WengHengcong on 2017/3/29.
//  Copyright © 2017年 JungleSong. All rights reserved.
//

import UIKit

public enum JSImageFormat {
    case unknown, png, jpeg, gif
}

extension UIImage {

    /// EZSE: Returns base64 string
    var base64: String {
        return UIImageJPEGRepresentation(self, 1.0)!.base64EncodedString()
    }

    /// EZSE: Returns compressed image to rate from 0 to 1

    /// 以JPEG压缩图片
    ///
    /// - Parameter rate: 压缩比
    /// - Returns: 返回图片时的Data
    public func compressImage(rate: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, rate)
    }

    /// EZSE: Returns Image size in Bytes

    /// 返回图片的大小
    ///
    /// - Returns: byte
    public func getSizeAsBytes() -> Int {
        return UIImageJPEGRepresentation(self, 1)?.count ?? 0
    }

    /// 返回图片的大小
    ///
    /// - Returns: kb
    public func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }

    /// EZSE: scales image

    /// 缩放图片
    ///
    /// - Parameters:
    ///   - image: 需要缩放的图片
    ///   - w: 宽度
    ///   - h: 高度
    /// - Returns: 压缩后图片
    public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// EZSE Returns resized image with width. Might return low quality

    /// 重置图片大小
    ///
    /// - Parameter width: 宽度
    /// - Returns: <#return value description#>
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// 重置图片大小
    ///
    /// - Parameter height: 高度
    /// - Returns: <#return value description#>
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// 自适应高度
    ///
    /// - Parameter width: 宽度
    /// - Returns: <#return value description#>
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    /// 自适应宽度
    ///
    /// - Parameter height: 高度
    /// - Returns: <#return value description#>
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }

    /// 截图
    ///
    /// - Parameter bound: 截图区域
    /// - Returns: <#return value description#>
    public func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("JSUI: Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("JSUI: Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
        return croppedImage
    }

    ///根据颜色创建图片
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    ///根据URL加载新图片
    public convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            print("EZSE: No image in URL \(urlString)")
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }

    /// 空图片
    ///
    /// - Returns: <#return value description#>
    public class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
