//
//版权所属：jiang
//文件名称：ControlExtensions.swift
//代码描述：***
//编程记录：
//[创建][2018/7/14][jiang]:新增文件

import Foundation
import UIKit

enum LinePosition:Int {
    case left = 0
    case right = 1
    case top = 2
    case bottom = 3
}

extension UIView{
    
    ///视图画边线，参数为位置（上下左右）
    func addLine(position:LinePosition){
        let rect = self.frame
        if rect.width <= 0 || rect.height <= 0{
            return
        }
        switch position {
        case .left:
            self.addLine(frame: CGRect(x: 0, y: 0, width: 1, height: rect.height), direction: LineDirection.vertical, style: .normal)
        case .right:
            self.addLine(frame: CGRect(x: rect.width-1, y: 0, width: 1, height: rect.height), direction: LineDirection.vertical, style: .normal)
        case .top:
            self.addLine(frame: CGRect(x: 0, y: 0, width: rect.width, height: 1), direction: LineDirection.horizontal, style: .normal)
        case .bottom:
            self.addLine(frame: CGRect(x: 0, y: rect.height-1, width: rect.width, height: 1), direction: LineDirection.horizontal, style: .normal)
        default:
            break
        }
    }
    
    ///视图中画线;
    ///frame为线的位置与尺寸（参考addBottomLine中的用法）
    func addLine(frame:CGRect, direction:LineDirection, style: LineSyle){
        self.addLine(frame: frame, direction:direction, style: style, color: .gray)
    }
    
    ///视图中画线;
    ///frame为线的位置与尺寸（参考addBottomLine中的用法）
    func addLine(frame:CGRect, direction:LineDirection, style: LineSyle, color:UIColor){
        if frame.width <= 0 || frame.height <= 0{
            return
        }
        let line = LineView(frame: frame)
        line.style = style
        line.direction = direction
        line.color = color
        self.addSubview(line)
    }
    
    ///添加边框
    func addBorder(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    ///设置圆角
    ///radius:圆角大小; corner:圆角位置，全部位置
    func setCorner(corner: UIRectCorner,radius: CGFloat){
        ThreadUtils.delay(0.15) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    ///为maskLayer添加边框
    func addBorderLayer(color:UIColor, width:CGFloat){
        ThreadUtils.delay(0.15) {
            let borderLayer = CAShapeLayer()
            borderLayer.frame = self.bounds
            borderLayer.lineWidth = width
            borderLayer.strokeColor = color.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            //let bezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10)
            //borderLayer.path = bezierPath.cgPath
            if let sharpLayer = self.layer.mask as? CAShapeLayer{
                borderLayer.path = sharpLayer.path
            }
            self.layer.insertSublayer(borderLayer, at: 0)
        }
    }
    
    ///给UIView设置角标
    func setBadge(badgeValue:String?){
        self.setBadge(badgeValue: badgeValue, offset: CGSize.zero)
    }
    
    ///给UIView设置角标
    func setBadge(badgeValue:String?, offset:CGSize){
        var badgeView:YYBageView?
        var placeholder:UIView
        let mainTag = self.getAddrTag()
        if let view = self.superview?.viewWithTag(mainTag){
            if view.tag == mainTag{  //
                placeholder = view
                if let potView = view.viewWithTag(15063){
                    badgeView = potView as? YYBageView
                }
            }
            else{
                placeholder = UIView()
            }
        }
        else{
            placeholder = UIView()
        }
        
        placeholder.tag = mainTag
        self.superview!.addSubview(placeholder)
        placeholder.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(offset.height)
            make.right.equalTo(self).offset(offset.width)
            make.width.height.equalTo(1)
        }
        if badgeView == nil{
            badgeView = YYBageView()
            badgeView!.tag = 15063
        }
        badgeView?.parentView = placeholder
        badgeView?.badgeText = badgeValue
    }
    
    ///以本身为样本复制视图
    func copyView() -> UIView {
        let tempArchive = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: tempArchive) as! UIView
    }
    
    func setShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSize(width: 2,height: 2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        self.layer.shadowRadius = 3;//阴影半径，默认3
    }
    
    ///截取内存地址后段作为Tag
    func getAddrTag() -> Int{
        let addr = String(format: "%p", self)
        let lastStr = addr.substring(from: addr.index(addr.endIndex, offsetBy: -5))
        return lastStr.hexToInt()
    }

}

extension UIButton{
    
    //修改状态
    func setStatus(enabled:Bool){
        self.isEnabled = enabled
        if(enabled){
            self.backgroundColor = UIUtils.getThemeColor()
        }
        else{
            self.backgroundColor = UIColor.lightGray
        }
    }
    
}

extension UITextField{
    
    ///添加左默认占位图
    func addLeftView(){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftViewMode = .always
    }
}


extension UIButton{
    ///设置主题样式
    func setThemeStyle(){
        self.backgroundColor = UIUtils.getThemeColor()
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
    }
}

extension UIImageView{
    func setImageCenterMode(){
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UITabBarItem{
    func setStyle(title:String, image:String, selectedImage:String){
        self.title = title
        self.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        self.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal);
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected)

    }
}

extension UIAlertController{
    ///添加动作
    func addAction(title: String, color: UIColor, action actionTarget: @escaping (_ action: UIAlertAction) -> Void) {
        let action = UIAlertAction(title: title, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            actionTarget(action)
        })
        action.setValue(color, forKey: "_titleTextColor")
        self.addAction(action)
    }
    
    ///添加“取消”动作
    func addCancelAction(title: String) {
        let action = UIAlertAction(title: title, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        //action.setValue(UIColor.red, forKey: "_titleTextColor")
        self.addAction(action)
    }
}



extension UICollectionView{
    
    ///设置流布局（Frame非零才生效）
    func setFlowLayout(lineItemsCount:CGFloat){
        let itemWidth = CGFloat(self.frame.size.width) / lineItemsCount
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        self.collectionViewLayout = flowLayout
    }
    
    ///设置流布局（Frame非零才生效）
    func setFlowLayout(lineItemsCount:CGFloat,itemHeight:CGFloat){
        let itemWidth = CGFloat(self.frame.size.width) / lineItemsCount
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        //flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self.collectionViewLayout = flowLayout
    }
    
    ///设置自动适配的流布局
    func setEstimateFlowLayout(size:CGSize){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //预估高度
        layout.estimatedItemSize = size
        self.collectionViewLayout = layout
    }
   
}

extension UIViewController {
    class func currentViewController() -> UIViewController {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        return UIViewController.findBestViewController(vc: vc!)
    }
    private class func findBestViewController(vc : UIViewController) -> UIViewController {
        
        if vc.presentedViewController != nil {
            return UIViewController.findBestViewController(vc: vc.presentedViewController!)
        } else if vc.isKind(of:UISplitViewController.self) {
            let svc = vc as! UISplitViewController
            if svc.viewControllers.count > 0 {
                return UIViewController.findBestViewController(vc: svc.viewControllers.last!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UINavigationController.self) {
            let nvc = vc as! UINavigationController
            if nvc.viewControllers.count > 0 {
                return UIViewController.findBestViewController(vc: nvc.topViewController!)
            } else {
                return vc
            }
        } else if vc.isKind(of: UITabBarController.self) {
            let tvc = vc as! UITabBarController
            if (tvc.viewControllers?.count)! > 0 {
                return UIViewController.findBestViewController(vc: tvc.selectedViewController!)
            } else {
                return vc
            }
        } else {
            return vc
        }
    }
}

extension UIView {
    
    // MARK: - 常用位置属性
    public var wy_x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var wy_y:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var wy_width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var wy_height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var wy_right:CGFloat {
        get {
            return self.wy_x + self.wy_width
        }
    }
    
    public var wy_bottom:CGFloat {
        get {
            return self.wy_y + self.wy_height
        }
    }
    
    public var wy_centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var wy_centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
}

extension UITextField {
    //MARK:-设置暂位文字的颜色
    var placeholderColor:UIColor {
        get {
            let color = self.value(forKeyPath: "_placeholderLabel.textColor")
            if(color == nil) {
                return UIColor.white
            }
            return color as! UIColor
        }
        set {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    //MARK:-设置暂位文字的字体
    var placeholderFont:UIFont {
        get {
            let font = self.value(forKeyPath: "_placeholderLabel.font")
            if(font == nil) {
                return UIFont.systemFont(ofSize: 14)
            }
            return font as! UIFont
        }
        set {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.font")
        }
    }
}

