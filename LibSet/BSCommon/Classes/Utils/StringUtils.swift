//
//  StringUtils.swift
//  Rent
//
//  Created by jiang on 19/3/17.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct StringUtils {
    
    public static let MAX_PIC_TEXT = 140
    public static let MAX_LONG_TEXT = 600
    public static let MAX_COVERLAST_TEXT = 70
    public static let MAX_TEXT_HEIGHT:CGFloat = 600
    public static let DEF_HEIGHT:CGFloat = 200
    
    public static let FONT_LARGE:CGFloat = 16
    public static let FONT_MIDDLE:CGFloat = 15
    public static let FONT_NORMAL:CGFloat = 13
    public static let FONT_SMALL:CGFloat = 12
    
    public static let TITLE_FONT_SIZE:CGFloat = 16
    
    public static let LINE_SPACING:CGFloat = 5.0
    
    public static let ERROR = "🛑ERROR: "
    
    public static let TIP = "🟡TIP: "
    
    public static let LOG = "🟢Log: "
    public static let NOTIFICATION_USER_REFRESH = "NOTIFICATION_USER_REFRESH"
    public static let NOTIFICATION_USER_RELOGIN = "NOTIFICATION_USER_RELOGIN"
        
    public static let REQUEST_ERROR = "加载中..."
    
//    RL0001  Admin  0
//    RL0002  顶级(代理商) 0
//    RL0003  一级  A
//    RL0004  二级  B
//    RL0005  终端  C
    
//    public static func replaceWidth(_ content:String)->String{
//        let screenWidth = Int(UIUtils.getScreenWidth())
//        return replaceWidth(screenWidth * 2, content:content)
//    }
//
//    public static func replaceWidth(_ width:Int,content:String)->String{
//        return replace(content, oldStr: "{0}", newStr: String(width))
//    }
//
//    public static func replaceShareWidth(_ content:String)->String{
//        let screenWidth = Int(UIUtils.getScreenWidth())
//        let tag1 = "_\(screenWidth * 2)w"
//        let tag2 = "/\(screenWidth * 2)/"
//        if content.contains(tag1){
//            return replace(content, oldStr: tag1, newStr: "_200w")
//        }else if content.contains(tag2){
//            return replace(content, oldStr: tag2, newStr: "/200/")
//        }else{
//            return content
//        }
//
//    }
    
    /**
     content:源字符串，oldStr:被替换目标串，newStr:新串
     */
    public static func replace(_ content:String,oldStr:String,newStr:String)->String{
        let newStr = content.replacingOccurrences(of: oldStr, with: newStr)
        return newStr
    }
    
    ///获取Label尺寸（限定宽度）
    public static func getBoundingRectWithString(_ str:String,labelWidth:CGFloat,textSize:CGFloat)->CGRect{
        return getBoundingRect( str, width:labelWidth, height:0, textSize:textSize)
    }
    
    ///获取字符串显示尺寸
    public static func getBoundingRect(_ str:String, width:CGFloat, height:CGFloat, textSize:CGFloat)->CGRect{
        var boundingRect:CGRect!
        if str.isEmpty {
            boundingRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }else{
            let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: textSize)]
            let options = NSStringDrawingOptions.usesLineFragmentOrigin
            let text:NSString = NSString(cString: str.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
            boundingRect = text.boundingRect(with: CGSize(width: width, height: 0), options: options, attributes: attributes, context: nil)
        }
        return boundingRect
    }
    
    
    public static func copyText(_ text:String){
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
        YYHUD.showToast("复制成功")
    }
    
    /**
     json字符串去反斜杠
     */
    public static func tidyJsonString(_ jsonStr:String) {
        //        replace(jsonStr, oldStr: "{\"", newStr: "{")
        //        replace(jsonStr, oldStr: "\"}", newStr: "}")
        //        replace(jsonStr, oldStr: "\":", newStr: ":")
        //        replace(jsonStr, oldStr: ":\"", newStr: ":")
        //        replace(jsonStr, oldStr: "\",", newStr: ",")
        //        replace(jsonStr, oldStr: ",\"", newStr: ",")
        
    }
    
    public static func getDictFromJson(_ json:String?) -> [String : AnyObject]?{
        if json == nil || json!.isEmpty || json!.hasPrefix("/Upload/"){
            return nil
        }
        
        let data = json!.data(using: String.Encoding.utf8)
        if let jsonRes = try? JSONSerialization.jsonObject(with: data!,options:JSONSerialization.ReadingOptions.mutableContainers){
            if (jsonRes as AnyObject).isKind(of: NSArray.self) && (jsonRes as AnyObject).count > 0{
                return (jsonRes as! NSArray)[0] as? [String : AnyObject]
            }
            else if (jsonRes as AnyObject).isKind(of: NSDictionary.self){
                return jsonRes as? [String : AnyObject]
            }
        }
        return nil
    }
    
    /**
     从文件JSON数组中获取路径(文件数组)
     */
    public static func getMultiFilePath(_ json:String?) -> [String]{
        if json == nil || json!.isEmpty || json!.hasPrefix("/Upload/"){
            return [String]()
        }
        
        let data = json!.data(using: String.Encoding.utf8)
        if let jsonRes = try? JSONSerialization.jsonObject(with: data!,
                                                           options: JSONSerialization.ReadingOptions.mutableContainers){
            if (jsonRes as AnyObject).isKind(of: NSArray.self) && (jsonRes as AnyObject).count > 0{
                let resArr = jsonRes as! NSArray
                var temArr = [String]()
                for item in resArr{
                    if let dict = item as? NSDictionary{
                        if let url = dict["FilePath"] as? String{
                            temArr.append(url)
                        }
                        else{
                            temArr.append("")
                        }
                    }
                    else if (item as AnyObject).isKind(of: NSArray.self){
                        temArr = item as! [String]
                    }
                }
                return temArr
            }
            else if (jsonRes as AnyObject).isKind(of: NSDictionary.self){
                let dict = jsonRes as! NSDictionary
                let url = dict["FilePath"] as! String
                return [url]
            }
        }
        return [String]()
    }
    
    //NSDictionary to jsonString
    public static func toJson(_ dict:NSDictionary) -> NSString{
        var jsonString = "";
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString as NSString;
    }
    
    //字典转Data
    public static func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        print("Json Str:\(str!)")
        return data
    }

    public static func getArrayWithFormatHtml(_ html:String) ->Array<String>{
        var newStr = html
        newStr = replace(newStr, oldStr: "</font><br><font color=red>", newStr: "#")
        newStr = replace(newStr, oldStr: "<font color=red>", newStr: "")
        newStr = replace(newStr, oldStr: "</font>", newStr: "")
        newStr = replace(newStr, oldStr: "<br>", newStr: "")
        return newStr.components(separatedBy: "#")
    }
    
    /**
     获取无格式的DeviceToken
     */
    public static func getDeviceTokenString(_ str:String) ->String{
        var newStr = str
        newStr = replace(newStr, oldStr: "<", newStr: "")
        newStr = replace(newStr, oldStr: ">", newStr: "")
        newStr = replace(newStr, oldStr: " ", newStr: "")
        return newStr
    }
    
    
    /**
     使用代码获取员工级别名
     */
    public static func getLevelName(_ code:String) -> String{
        var res = ""
        switch code {
        case "0":
            res = "代理商"
            break
        case "A":
            res = "一级员工"
            break
        case "B":
            res = "二级员工"
            break
        case "C":
            res = "终端/门店"
            break
            
        default:
            break
        }
        
        return res
    }
    
    
    /**
     使用代码获取员工级别名
     */
    public static func getBankName(_ code:String) -> String{
        var res = ""
        if (!isValidateBankCard(code as NSString)){
            return res
        }
        let card = code as NSString
        let plistPath = Bundle.main.path(forResource: "bank", ofType: "plist")!
        let resultDic = NSDictionary(contentsOfFile: plistPath)
        if let keys = resultDic?.allKeys{
            let bankBin = keys as NSArray
            for idx in 0..<5 {
                var cardBin = card.substring(with: NSMakeRange(0, 6-idx))
                if bankBin.contains(cardBin) {
                    res = (resultDic![cardBin] as! String)
                    break
                }
                else if idx > 0 {
                    cardBin = card.substring(with: NSMakeRange(0, 6+idx))
                    if bankBin.contains(cardBin) {
                        res = (resultDic![cardBin] as! String)
                        break
                    }
                }
            }
        }
        return res
    }
    
    /**
     判断用户名合法
     */
    public static func isUserNameValid(_ name:String) -> Bool{
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
    
    /**
     判断数字
     */
    public static func isNumber(_ number:String) -> Bool{
        let regex = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: number)
    }
    
    /**
     判断正浮点数
     */
    public static func isValidAccount(_ account:String) -> Bool{
        let regex = "^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: account)
    }
    
    
    //验证电子邮箱格式
    public static func isEmail(_ name:String) -> Bool{
        let regex = "^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
        
    }
    
    /**
     secondStr: 无NSRange时必须有
     NSRange: 可设置为nil
     */
    public static func getColoredString(_ firstStr:String, secondStr:String, color:UIColor, colorRange:NSRange?) -> NSMutableAttributedString{
        let totalStr = firstStr + secondStr
        let attributedString = NSMutableAttributedString(string: totalStr, attributes: nil)
        
        var range = colorRange
        if colorRange == nil{
            var start = 0
            var length = 0
            if !firstStr.isEmpty{
                start = (firstStr as NSString).length
            }
            if !secondStr.isEmpty{
                length = (secondStr as NSString).length
            }
            range = NSMakeRange(start, length)
        }
        
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor:color], range: range!)
        
        return attributedString
    }
    
    public static func getColoredString(_ normarlStr:String,coloredStr:String, color:UIColor) -> NSMutableAttributedString{
        let totalStr = normarlStr + coloredStr
        let attributedString = NSMutableAttributedString(string: totalStr, attributes: nil)
        
        var start = 0
        var length = 0
        if !normarlStr.isEmpty{
            start = (normarlStr as NSString).length
        }
        if !coloredStr.isEmpty{
            length = (coloredStr as NSString).length
        }
        
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor:color], range: NSMakeRange(start, length))
        
        return attributedString
    }
    
    public static func getMax(_ count1:Float,count2:Float)->Float{
        if count1 > count2 {
            return count1
        }else {
            return count2
        }
    }
    
    public static func getMin(_ count1:Float,count2:Float)->Float{
        if count1 < count2 {
            return count1
        }else {
            return count2
        }
    }
    
    
    public static func isValidateMobile(_ phone:NSString) -> Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: phone) == true)
            || (regextestcm.evaluate(with: phone)  == true)
            || (regextestct.evaluate(with: phone) == true)
            || (regextestcu.evaluate(with: phone) == true))
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    public static func isValidateBankCard(_ cardNumber: NSString) -> Bool {
        if cardNumber.length < 15 || cardNumber.length > 21 || !StringUtils.isNumber(cardNumber as String){
            return false
        }
        //        if cardNumber.hasPrefix("955"){
        //            return true
        //        }
        var cardNo = cardNumber as String
        var oddsum: Int = 0
        //奇数求和
        var evensum: Int = 0
        //偶数求和899
        var allsum: Int = 0
        let cardNoLength = Int(cardNo.count)
        let index1 = cardNo.index(cardNo.endIndex, offsetBy: -1)
        let lastNum = Int(cardNo.substring(from: index1))!
        let index2 = cardNo.index(cardNo.startIndex, offsetBy: cardNo.count-1)
        cardNo = cardNo.substring(to: index2)
        
        var i = cardNoLength - 1
        while i >= 1 {
            let tmpString: String = (cardNo as NSString).substring(with: NSRange(location: i - 1, length: 1))
            var tmpVal = Int(tmpString) ?? 0
            if cardNoLength % 2 == 1 {
                if (i % 2) == 0 {
                    tmpVal *= 2
                    if tmpVal >= 10 {
                        tmpVal -= 9
                    }
                    evensum += tmpVal
                }
                else {
                    oddsum += tmpVal
                }
            }
            else {
                if (i % 2) == 1 {
                    tmpVal *= 2
                    if tmpVal >= 10 {
                        tmpVal -= 9
                    }
                    evensum += tmpVal
                }
                else {
                    oddsum += tmpVal
                }
            }
            i -= 1
        }
        allsum = oddsum + evensum
        allsum += lastNum
        if (allsum % 10) == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    
    
    //设置行间距
    public static func setLineSpacing(_ text:String,lineSpacing:CGFloat,alignment:NSTextAlignment)->NSMutableAttributedString{
        
        let attributed = NSMutableAttributedString(string:text)
        let paragraphtyle = NSMutableParagraphStyle()
        paragraphtyle.lineSpacing = lineSpacing
        paragraphtyle.alignment = alignment
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphtyle, range:NSMakeRange(0,text.count))
        return attributed
    }
    
    public static func getFormatUserName(_ name:String,length:Int) -> String{
        var res = name as NSString
        if res.length <= length{
            return name
        }
        
        res = res.substring(with: NSMakeRange(0, length)) as NSString
        res = (res as String) + "..." as NSString
        return res as String
    }
    
    
    /**
     获取名字的首字母
     */
    func getTitleChar(_ name:String) -> String{
        let strMutable = NSMutableString(string: name)
        let str = strMutable as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformToLatin, false)
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false)
        let pin = strMutable.capitalized
        let first = (pin as NSString) .substring(to: 1)
        return first
    }
    
    
    /**
     从文件JSON中获取路径(单一文件，非数组)
     如果是数组，则取出第一个元素
     */
    public static func getFilePath(_ fileJson:String) -> String{
        var res = ""
        if fileJson.isEmpty{
            return res
        }
        if fileJson.hasPrefix("["){
            if let dict = StringUtils.getDictFromJson(fileJson){
                if dict.count > 0{
                    if let path = dict["FilePath"] as? String{
                        res = path
                    }
                }
            }
        }
        else if fileJson.hasPrefix("http"){
            res = fileJson
        }
        else if fileJson.hasPrefix("/Upload")
            || fileJson.hasPrefix("/upload")
            || fileJson.hasPrefix("/wap"){
            res = NetWorkConfig.BASE_URL + fileJson
        }
        else{
            res = "http://\(fileJson)"
        }
        
        return res
    }

    /// 生成一个随机字符串
    ///
    /// - Parameters:
    ///   - count: 生成多少位的字符串
    ///   - type: 字符串类型，0-包含大小写字母和数字 ； 1-只包含大小写 ； 2-只包含大写 ； 3-只包含小写 ； 4-只包含数字
    /// - Returns: 随机字符串
    public static func returnRandomString(withCount count: Int, type: Int) -> String? {
        
        //定义一个包含数字，大小写字母的字符串
        var strAll = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        switch type {
        case 1:
            strAll = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case 2:
            strAll = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case 3:
            strAll = "abcdefghijklmnopqrstuvwxyz"
        case 4:
            strAll = "0123456789"
        default:
            strAll = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        //定义一个结果
        var result = ""
        for _ in 0..<count {
            let index = Int(arc4random_uniform(UInt32(strAll.count)))
            result.append(strAll[strAll.index(strAll.startIndex, offsetBy: index)])
        }
        print("随机字符串 = \(result)")
        return result
    }
    
}

