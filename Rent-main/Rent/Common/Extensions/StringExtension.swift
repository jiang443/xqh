//
//版权所属：jiang
//文件名称：StringExtension.swift
//代码描述：String分类
//编程记录：
//[创建][2018/3/7][jiang]:新增文件

import Foundation

public let GroupDefaults = UserDefaults(suiteName: "com.temp")!

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

extension String {
    //获取子字符串
    //eg: cString.substingInRange(r: 0..<1) 取第一个字符
    func substingInRange(r: CountableRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return self.substring(with:startIndex..<endIndex)
    }
    
    func float2() -> String{
        var res = "0.00"
        if let num = Double(self){
            res = String(format: "%.2f",num)
        }
        return res
    }
    
    func intValue() -> Int{
        var res = 0
        if let num = Int(self){
            res = num
        }
        return res
    }
    
    func doubleValue() -> Double{
        var res = 0.0
        if let num = Double(self){
            res = num
        }
        return res
    }
    
    func isGreaterThan(str:String) -> Bool{
        return self.compare(str).rawValue > 0   //1
    }
    
    func isEqualTo(str:String) -> Bool{
        return self.compare(str).rawValue == 0  //0
    }
    
    func isLessThan(str:String) -> Bool{
        return self.compare(str).rawValue < 0   //-1
    }
    
    /**
     子串替换。 oldStr:被替换目标串，newStr:新串
     */
    func replace(oldStr:String,newStr:String)->String{
        return self.replacingOccurrences(of: oldStr, with: newStr)
    }
    
    ///16进制转10进制
    func hexToInt() -> Int {
        var str = self.uppercased()
        str = str.replace(oldStr: "0X", newStr: "")
        var sum = 0
        for i in str {
            let n = Int(i.unicodeScalars.first!.value)   //获取ASCII码
            sum = sum * 16 + n - 48 // 0-9 从48开始
            // A-Z 从65开始，但有初始值10，所以应该是减去55
            if n >= 65 {
                sum -= 7
            }
        }
        return sum
    }

}

