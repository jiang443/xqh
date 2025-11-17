//
//版权所属：jiang
//文件名称：ControlExtensions.swift
//代码描述：***
//编程记录：
//[创建][2018/7/14][jiang]:新增文件

import Foundation

public enum LinePosition:Int {
    case left = 0
    case right = 1
    case top = 2
    case bottom = 3
}

public extension UIView{
    
    ///视图画边线，参数为位置（上下左右）
    public func addLine(position:LinePosition){
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
    public func addLine(frame:CGRect, direction:LineDirection, style: LineSyle){
        self.addLine(frame: frame, direction:direction, style: style, color: .gray)
    }
    
    ///视图中画线;
    ///frame为线的位置与尺寸（参考addBottomLine中的用法）
    public func addLine(frame:CGRect, direction:LineDirection, style: LineSyle, color:UIColor){
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
    public func addBorder(){
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    ///给UIView设置角标
    public func setBadge(badgeValue:String?){
        self.setBadge(badgeValue: badgeValue, offset: CGSize.zero)
    }
    
    ///给UIView设置角标
    public func setBadge(badgeValue:String?, offset:CGSize){
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
    
    ///截取内存地址后段作为Tag
    func getAddrTag() -> Int{
        let addr = String(format: "%p", self)
        let lastStr = addr.substring(from: addr.index(addr.endIndex, offsetBy: -5))
        return lastStr.hexToInt()
    }
}

public extension UIButton{
    
    //修改状态
    public func setStatus(enabled:Bool){
        self.isEnabled = enabled
        if(enabled){
            self.backgroundColor = UIUtils.getThemeColor()
        }
        else{
            self.backgroundColor = UIColor.lightGray
        }
    }
    
}

public extension UIControl{
    ///暂停一断时间处于无效状态，避免多次触发
    public func breakFor(_ time:Double){
        self.isEnabled = false
        ThreadUtils.delay(time) {
            self.isEnabled = true
        }
    }
}

public extension UIBarItem{
    ///暂停一断时间处于无效状态，避免多次触发
    public func breakFor(_ time:Double){
        self.isEnabled = false
        ThreadUtils.delay(time) {
            self.isEnabled = true
        }
    }
}

public extension UITextField{
    
    ///添加左默认占位图
    public func addLeftView(){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftViewMode = .always
    }
    
    ///限制长度
    public func checkLimitedSize(_ maxLen: Int){
        let toBeString = self.text! as NSString
        if toBeString.length > maxLen{
            let range = toBeString.rangeOfComposedCharacterSequence(at: maxLen)
            if range.length == 1{
                self.text = toBeString.substring(to: maxLen)
            }
            else{
                let range = toBeString.rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: maxLen))
                self.text = toBeString.substring(with: range)
            }
        }
    }
    
    
}


public extension UIButton{
    ///设置主题样式
    public func setThemeStyle(){
        self.backgroundColor = UIUtils.getThemeColor()
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
    }
}

public extension UIImageView{
    public func setImageCenterMode(){
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

public extension UITabBarItem{
    public func setStyle(title:String, image:String, selectedImage:String){
        self.title = title
        self.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        self.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal);
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected)

    }
}

public extension UIAlertController{
    ///添加动作
    public func addAction(title: String, color: UIColor, action actionTarget: @escaping (_ action: UIAlertAction) -> Void) {
        let action = UIAlertAction(title: title, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            actionTarget(action)
        })
        action.setValue(color, forKey: "_titleTextColor")
        self.addAction(action)
    }
    
    ///添加“取消”动作
    public func addCancelAction(title: String) {
        let action = UIAlertAction(title: title, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        //action.setValue(UIColor.red, forKey: "_titleTextColor")
        self.addAction(action)
    }
}

public extension UITableViewCell{
    ///添加底边线
    public func addLine(){
        let tag = 10611
        var lineView:UIView!
        if let view = self.viewWithTag(tag){
            lineView = view
        }
        else{
            lineView = UIView()
            lineView.backgroundColor = UIColor.color(hex: "#bbb")
            lineView.tag = tag
            self.addSubview(lineView)
            lineView.snp.makeConstraints {[unowned self] (make) in
                make.left.equalTo(self).offset(15)
                make.right.equalTo(self).offset(-8)
                make.bottom.equalTo(self).offset(-0.5)
                make.height.equalTo(0.5)
            }
        }
    }
}


public extension UITableView{
    
    ///动态修改HeaderView.
    ///在Block修改HeaderView内容
    public func modifyHeaderView( animated:Bool, configBlock:((_ headerView:UIView?) -> Void)? ){
        if let headerView = self.tableHeaderView{
            if animated{
                self.beginUpdates()
            }
            headerView.removeFromSuperview()
            self.tableHeaderView = nil
            configBlock?(headerView)    //在此修改HeaderView内容
            self.tableHeaderView = headerView
            if animated{
                self.endUpdates()
            }
        }
        else{
            configBlock?(nil)
        }
    }

}
