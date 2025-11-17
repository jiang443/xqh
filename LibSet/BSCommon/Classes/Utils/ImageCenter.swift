//
//  ImageUtils.swift
//  Rent
//
//  Created by jiang on 19/3/18.
//  Copyright © 2019年 tmpName. All rights reserved.
//

//ui层的回调
typealias UIGetPhotosStart = () ->Void
typealias UIGetPhotosSuccess = (Bool,AnyObject,String) ->Void
typealias UIGetPhotosFailed = (String) ->Void

import Foundation
import Kingfisher
import AssetsLibrary

public class ImageCenter {
    
    static let PHOTO_MIN_WIDTH = UIUtils.getScreenHeight() / 2
    static let PHOTO_MAX_SCALE = 2
    
    public class ImageOption {
        var uiViewContentModel = UIView.ContentMode.scaleToFill
        var clipsToBounds = false
    }
    
    static func getOptionWithScaleAspectFit() ->ImageOption{
        let info = ImageOption()
        info.clipsToBounds = true
        info.uiViewContentModel = UIView.ContentMode.scaleAspectFit
        return info
    }
    
    static func getOptionWithScaleAspectFill() ->ImageOption{
        let info = ImageOption()
        info.clipsToBounds = true
        info.uiViewContentModel = UIView.ContentMode.scaleAspectFill
        return info
    }
    
    /*
     默认的是中心裁剪的
     */
    public static func display(_ imageView:UIImageView?,path:String){
        
        display(imageView, path: path, placeholder: nil)
        
    }
    
    public static func display(_ imageView:UIImageView?,path:String, placeholder: UIImage?){
        if imageView == nil{
            return
        }
        
        DispatchQueue.main.async {
            var url = path
            if url.hasPrefix("/Upload/") || url.hasPrefix("/upload/"){
                url = NetWorkConfig.BASE_URL + path
            }
            display(imageView!, path: url, option: getOptionWithScaleAspectFill(), placeholder: placeholder)
        }
        
    }
    
    public static func display(_ imageView:UIImageView,path:String,option:ImageOption){
        
        display(imageView, path: path, option: option, placeholder: nil)
    }
    
    public static func display(_ imageView:UIImageView,path:String,option:ImageOption, placeholder: UIImage?){
        
        if(path.isEmpty){
            imageView.image = (placeholder ?? UIUtils.getDefautImage())
            return
        }
        
        imageView.contentMode = option.uiViewContentModel
        imageView.clipsToBounds = option.clipsToBounds
        
        if path.contains("http://") || path.contains("https://"){
            var fPath = path
            if path.contains(".oss-cn")
                && path.contains(".webp")
                && !path.contains("image/format"){
                fPath = "\(path)?x-oss-process=image/format,jpg"
            }
            //[KingfisherOptionsInfoItem.Transition(ImageTransition.Fade(1))]
            if let url = URL(string : fPath){
                //关于GIF的设置。使用Kingfisher提供的AnimatedImageView也可实现
                //KingfisherManager.shared.defaultOptions = options
                if path.hasSuffix(".gif"){
                    let gifOptions:KingfisherOptionsInfo =  [.backgroundDecode, .downloadPriority(1.0)]
                    imageView.kf.setImage(with: url, placeholder:(placeholder ?? UIUtils.getDefautImage()), options:gifOptions)
                }
                else{
                    imageView.kf.setImage(with: url, placeholder:(placeholder ?? UIUtils.getDefautImage()),
                                          options:nil)
                }
            }
            
        } else if path.contains("assets-library://"){
            //[KingOptionsInfoItem.Transition(KingImageTransition.Fade(1))]
            //imageView.k_displayWithAsset(path, placeholderImage: UIUtils.getDefautImage(), optionsInfo: nil)
            
        } else if path.contains("/Users/"){
            let fileManager = FileManager.default
            let data:Data? = fileManager.contents(atPath: path)
            if data != nil {
                let image = UIImage(data: data!)
                imageView.image = image
            }else {
                imageView.image = (placeholder ?? UIUtils.getDefautImage())
            }
        }
        else{
            let image = UIImage(named: path)
            imageView.image = image
        }
    }
    
    /**
     保存图片在沙盒中，并返回路径
     */
    @discardableResult
    public class func cacheImage(_ image:UIImage)->String{
        return cacheImage(image, fileName: nil)
    }
    
    /**
     保存图片在沙盒中，并返回路径
     */
    @discardableResult
    public class func cacheImage(_ image:UIImage, fileName:String?)->String{
        var newImagePath = ""
        let imageData = image.jpegData(compressionQuality: 1.0)
        let documentsPath = NSHomeDirectory() + "/Documents/Caches/Images"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: documentsPath){
            do {
                try fileManager.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
            }catch {
                return ""
            }
        }
        
        var name = "\(TimeUtils.getCurrentTimeString("yyyyMMdd_HHmmss")).png"
        if fileName?.count > 0{
            name = "\(fileName!).png"
        }
        else if let md5Str = OCUtils.getMD5(with: imageData!){
            name = "\(md5Str).png"
        }
        newImagePath = documentsPath + "/\(name)"
        fileManager.createFile(atPath: newImagePath, contents: imageData, attributes: nil)  //覆盖写入
        
        return newImagePath
    }
    
    ///获取沙盒中的图片对象
    public static func getCachedImage(name:String) -> UIImage?{
        let filePath = NSHomeDirectory() + "/Documents/Caches/Images/\(name).png"
        return UIImage(contentsOfFile: filePath)

    }
    
    /**
     高亮状态的图片
     */
    public static func getImageHighlighted()->UIImage{
        let color = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 0.1)
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     压缩图片尺寸
     */
    public class func compressImage(_ sourceImage:UIImage,targetWidth:CGFloat) -> UIImage{
        let imagesize = sourceImage.size
        let width = imagesize.width
        let height = imagesize.height
        let ratio = targetWidth/width
        if ratio < 1{
            let targetHeight = (ratio)*height
            UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
            sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        }
        else{
            return sourceImage
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
     压缩图片大小
     */
    public class func resizeImage(_ image:UIImage) -> Data{
        let newImage = self.compressImage(image, targetWidth: 1334) //尺寸压缩
        //let data = UIImageJPEGRepresentation(newImage,1.0);
        //let length = data!.count/1024;  //单位转为KB
        let ratio:CGFloat = 0.5   //[0.5-1]压缩系数，结果大小取决于图片
        //let imgData = UIImageJPEGRepresentation(newImage, ratio)  //质量压缩
        let imgData = newImage.jpegData(compressionQuality: ratio)
        //let res = UIImage(data: imgData!)
        return imgData!
    }
    
    
    /**
     * 修正图片旋转
     * http://www.jianshu.com/p/abbd53051156
     */
    public func fixOrientation(_ aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        
        //这里需要注意下CGImageGetBitmapInfo，它的类型是Int32的，CGImageGetBitmapInfo(aImage.CGImage).rawValue，这样写才不会报错
        let ctx: CGContext = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: aImage.cgImage!.colorSpace!, bitmapInfo: aImage.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.height, height: aImage.size.width))
        default:
            ctx.draw(aImage.cgImage!, in: CGRect(x: 0, y: 0, width: aImage.size.width, height: aImage.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    /// 使用URL获取UIImage
    ///
    /// - Parameter fileURL: url string
    /// - Returns: UIImage
    public class func getImage(_ fileURL: String) -> UIImage? {
        var image: UIImage?
        var url = fileURL
        if url.hasPrefix("/Upload/") || url.hasPrefix("/upload/"){
            url = NetWorkConfig.BASE_URL + fileURL
        }
        if let url = URL(string: url){
            if let data = NSData(contentsOf: url){
                image = UIImage(data: data as Data)
                return image
            }
        }
        return nil
    }
    
    ///从默认图片Bundle中获取Image
    public class func bundleImage(_ imageName:String, with cls:AnyClass) -> UIImage{
        let thisBundle = Bundle(for: cls)   //类所在的Bundle
        var bundle: Bundle? = nil
        //查找Images.bundle
        if let bundleURL = thisBundle.url(forResource: "Images", withExtension: "bundle") {
            bundle = Bundle(url: bundleURL)
        }
        return UIImage(named: imageName, in: bundle, compatibleWith: nil) ?? UIImage()
    }
    
    
}
