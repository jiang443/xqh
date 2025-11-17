//
//  UIUtils.swift
//  Rent
//
//  Created by jiang on 19/3/11.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

/*!
*  UI工具类
*/
class UIUtils:NSObject {
    
    /// 屏幕宽度
    var screenWidth:CGFloat {
        get{
            return  UIScreen.main.bounds.width
        }
        set {return;}
    }
    
    /// 屏幕高度
    var screenHeight:CGFloat {
        get{
            return  UIScreen.main.bounds.height
        }
        set {return;}
    }
    
    class func getThemeColor() -> UIColor{
        return getLightBlueColor()
    }
    
    /// 主题红色
    var themeRedColor:UIColor? {
        get{
            return  UIUtils.colorWithHexString("#F56971")
        }
        set {return;}
    }
   
    /*!
     * 从16进制颜色值获取UIColor
     */
     class func colorWithHexString (_ hex:String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespaces).uppercased()
        // String should be 6 or 8 characters
        // 判断前缀
        if cString.hasPrefix("#") {
            cString = ((cString as NSString).substring(from: 1))
        }
        if cString.count == 3{
            let s1 = cString.substingInRange(r: 0..<1)
            let s2 = cString.substingInRange(r: 1..<2)
            let s3 = cString.substingInRange(r: 2..<3)
            cString = "\(s1)\(s1)\(s2)\(s2)\(s3)\(s3)"
        }
        else if cString.count != 6 {
            return UIColor.clear
        }
        
        // 从六位数值中找到RGB对应的位数并转换
        var range = NSRange(location: 0, length: 0)
        range.location = 0
        range.length = 2
        //RGB
        let rString: String = (cString as NSString).substring(with: range)
        range.location = 2
        let gString: String = (cString as NSString).substring(with: range)
        range.location = 4
        let bString: String = (cString as NSString).substring(with: range)
        // Scan values
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat((Float(r) / 255.0)), green: CGFloat((Float(g) / 255.0)), blue: CGFloat((Float(b) / 255.0)), alpha: 1.0)
    }
    
    
    class func getBackgroundColor() -> UIColor{
        //return  colorWithHexString("#EEEEEE") //F3F3F3
        return UIColor(white: 0.95, alpha: 1)
    }
    
    
    class func getLineGrayColor() -> UIColor{
        return  colorWithHexString("#DCDCDC")
    }
    
    class func getTextColor()->UIColor{
        return colorWithHexString("#5E5E5E")
    }
    
    class func getLineBackgroundColor()->UIColor{
        return colorWithHexString("#EEEEEE")
    }
    
    class func getRedColor() -> UIColor{
        return  colorWithHexString("#FC5253")
    }
    
    class func getGreenColor() -> UIColor{
        return UIColor.color(withHexString: "#33cc66")   //00CC66
    }
    
    class func getDarkGreenColor() -> UIColor{
        return colorWithHexString("#01b18a")
    }
    
    class func getLightBlueColor() -> UIColor{
        return colorWithHexString("#35AAED")
    }
    
    class func getBlueColor() -> UIColor{
        return colorWithHexString("#2589C2")
        //UIUtils.colorWithHexString("0066ff"))
    }
    
    class func getTextBlueColor() -> UIColor{
        return colorWithHexString("#0066ff")
    }
    
    class func getOrangeColor() -> UIColor{
        return colorWithHexString("#F8B551")
    }

    class func getBlackColor() -> UIColor{
        return colorWithHexString("#2e2d32")
    }
    
    class func getDoctorBlue() -> UIColor{
        return colorWithHexString("#5b88f3")
    }
    
    class func getBlueBackground() -> UIColor{
        return colorWithHexString("#f5f8fe")
    }
    
    class func getIconBackColor() -> UIColor{
        return colorWithHexString("#f7faff")
    }
    
    
    class func getScreenWidth()->CGFloat{
        return  UIScreen.main.bounds.width
    }
    
    class func getScreenHeight()->CGFloat{
        return  UIScreen.main.bounds.height
        
    }
    
    /*!
    * 默认图片
    */
    class func getDefautImage() -> UIImage{
        return UIImage(named: "img")!
    }
    
    class func getAppDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    class func getMainViewController() -> MainViewController {
//        return MainViewController.getInstance()
//    }

    
    class func getHighlightColor() -> UIColor{
        let color = UIColor(red: 94/255, green: 94/255, blue: 94/255, alpha: 0.1)
        return color
    }
    
    /**
     虚线框
     */
    class func drawDashRect(_ view:UIView,cornerRadius:CGFloat){
        let border = CAShapeLayer()
        border.strokeColor = UIColor.gray.cgColor;
        border.fillColor = nil;
        border.path = UIBezierPath(roundedRect: view.bounds, cornerRadius:cornerRadius).cgPath;
        border.frame = view.bounds;
        border.lineWidth = 1
        border.lineCap = CAShapeLayerLineCap(rawValue: "square")
        border.lineDashPattern = [4, 4];
        view.layer.addSublayer(border);
    }
    
    /**
     *  获取字符串的宽度和高度
     */
    class func getTextRectSize(_ text:NSString,font:UIFont,width:CGFloat) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let rect:CGRect = text.boundingRect(with: CGSize(width: width, height: 0),
                options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
                attributes: attributes,
                context: nil)
        //        println("rect:\(rect)");
        return rect;
    }
    
    /**
     获取文本文件内容
     */
    class func getTextFile(_ name:String,type:String) -> String{
        let path = Bundle.main.path(forResource: name, ofType: type)
        let content = try! NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
        return content as String
    }
    
    class func writeFile(_ content:String, fileName:String) -> Bool{
//        let path = NSBundle.mainBundle().pathForResource(name, ofType: type)
//        if path == nil || path!.isEmpty{
//            return false
//        }
        let path = getFilePath() + fileName
        //定义可变数据变量
        let data = NSMutableData()
        //向数据对象中添加文本，并制定文字code
        data.append(content.data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        //用data写文件
        FileManager.default.createFile(atPath: path, contents: data as Data, attributes: nil)
        data.write(toFile: path, atomically: true)
        //try! content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        return true
    }
    
    class func readdFile(_ fileName:String) -> String{
//        let path = NSBundle.mainBundle().pathForResource(name, ofType: type)
//        if path == nil || path!.isEmpty{
//            return ""
//        }
        let path = getFilePath() + fileName
        //从url里面读取数据，读取成功则赋予readData对象，读取失败则走else逻辑
        if let readData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            //如果内容存在 则用readData创建文字列
            if let content = NSString(data: readData, encoding: String.Encoding.utf8.rawValue){
                return content as String
            }
        }
        return ""
    }
    
    class func getFilePath() -> String{
        let path = NSHomeDirectory() + "/Documents/files/"
        let fileManager = FileManager.default
        try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        return path
    }
    
    class func isIphone5() -> Bool{
        let width = UIUtils.getScreenWidth()
        return width == 320
    }
    
    class func setLabel(_ label:UILabel){
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        label.textAlignment = .left
    }
    
    ///获取当前屏幕显示的viewcontroller
    class func getCurrentVC() -> UIViewController? {
        let rootViewController = UIUtils.getAppDelegate().window?.rootViewController
        let currentVC = self.getCurrentVCFrom(rootViewController!)
        return currentVC
    }
    
    class func getCurrentVCFrom(_ rootVC: UIViewController) -> UIViewController? {
        var currentVC: UIViewController?
        var rootViewController = rootVC
        if rootViewController.presentedViewController != nil {
            // 视图是被presented出来的
            rootViewController = rootViewController.presentedViewController!
        }
        if (rootViewController is UITabBarController) {
            // 根视图为UITabBarController
            currentVC = self.getCurrentVCFrom((rootViewController as! UITabBarController).selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            // 根视图为UINavigationController
            if let vc = (rootViewController as! UINavigationController).visibleViewController{
                currentVC = self.getCurrentVCFrom(vc)
            }
        }
        else {
            // 根视图为非导航类
            currentVC = rootViewController
        }
        
        if currentVC == nil{
            return rootViewController
        }
        else{
            return currentVC!
        }
    }
    
    
    /**
     tabbar显示小红点
     @param index 第几个控制器显示，从0开始算起
     @param tabbarNum tabbarcontroller一共多少个控制器
     */
    class func showBadgeOnItmIndex(_ tabBar:UITabBar, index: Int, itemCount: Int) {
        removeBadgeOnItemIndex(tabBar, index: index)
        //label为小红点，并设置label属性
        let label = UILabel()
        label.tag = 1000 + index
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.backgroundColor = UIColor.red
        let tabFrame = tabBar.frame
        //计算小红点的X值，根据第index控制器，小红点在每个tabbar按钮的中部偏移0.1，即是每个按钮宽度的0.6倍
        let percentX: CGFloat = (CGFloat(index) + 0.6)
        let tabBarButtonW: CGFloat = tabFrame.width / CGFloat(itemCount)
        let x: CGFloat = percentX * tabBarButtonW
        let y: CGFloat = 0.1 * tabFrame.height
        //10为小红点的高度和宽度
        label.frame = CGRect(x: x, y: y, width: 10, height: 10)
        tabBar.addSubview(label)
        //把小红点移到最顶层
        tabBar.bringSubviewToFront(label)
    }
    
    
    /**
     隐藏红点
     @param index 第几个控制器隐藏，从0开始算起
     */
    class func hideBadgeOnItemIndex(_ tabBar:UITabBar, index: Int) {
        self.removeBadgeOnItemIndex(tabBar, index: index)
    }
    
    
    
    /**
     移除控件
     @param index 第几个控制器要移除控件，从0开始算起
     */
    class func removeBadgeOnItemIndex(_ tabBar:UITabBar, index: Int) {
        for subView: UIView in tabBar.subviews {
            if subView.tag == 1000 + index {
                subView.removeFromSuperview()
            }
        }
    }
    
    /**
     给视图添加Touch手势方法
     */
    class func addSelector(_ view:UIView, action: Selector){
        let gesture = UITapGestureRecognizer(target: self, action: action)
        gesture.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        //gesture.view
    }
    
    //添加取消按钮  www.jianshu.com/p/1c052c761a15
    class func addCancelActionTarget(_ alertController: UIAlertController, title: String) {
        let action = UIAlertAction(title: title, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        //action.setValue(UIColor.red, forKey: "_titleTextColor")
        alertController.addAction(action)
    }
    
    //添加对应的title 也可以传进一个数组的titles  这里只传一个是为了方便实现每个title的对应的响应事件不同的需求不同的方法
    class func addActionTarget(_ alertController: UIAlertController, title: String, color: UIColor, action actionTarget: @escaping (_ action: UIAlertAction) -> Void) {
        let action = UIAlertAction(title: title, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            actionTarget(action)
        })
        action.setValue(color, forKey: "_titleTextColor")
        alertController.addAction(action)
    }
    
    class func isIPhoneX() -> Bool{
        var res = false
        if #available(iOS 11.0, *) {
            res = UIUtils.getAppDelegate().window?.safeAreaInsets.bottom > 0
        }
        return res
    }
    
    
    ///获取CollectionView流布局（正方形单元）
    class func getFlowLayout(lineItemsCount:CGFloat, bodyWdith:CGFloat) -> UICollectionViewFlowLayout{
        let itemWidth = CGFloat(bodyWdith) / lineItemsCount
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
    
    ///获取CollectionView流布局（矩形单元）
    class func getFlowLayout(lineItemsCount:CGFloat, bodyWdith:CGFloat, itemHeight:CGFloat) -> UICollectionViewFlowLayout{
        let itemWidth = CGFloat(bodyWdith) / lineItemsCount
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
    
    ///底部控制栏高度
    class func getBottomViewHeight() -> CGFloat{
        var height:CGFloat = 45
        if UIUtils.isIPhoneX(){
            height = 60
        }
        return height
    }
    


    
}
