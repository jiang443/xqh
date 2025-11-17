//
//版权所属：jiang
//文件名称：UIColor+Hex.swift
//代码描述：UIColor的扩展，支持16进制颜色
//编程记录：
//[创建][2018/1/11][jiang]:新增文件

import Foundation

public extension UIColor{
    
    //字符串转颜色
    public class func color(hex value: String) -> UIColor {
        var cString: String = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
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
        var range = NSRange(location: 0, length: 0)
        range.location = 0
        range.length = 2
        let rString: String = (cString as NSString).substring(with: range)
        range.location = 2
        let gString: String = (cString as NSString).substring(with: range)
        range.location = 4
        let bString: String = (cString as NSString).substring(with: range)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat((Float(r) / 255.0)), green: CGFloat((Float(g) / 255.0)), blue: CGFloat((Float(b) / 255.0)), alpha: 1.0)
    }

    
    
    
}
