//
//  BSUtils.swift
//  XQH
//
//  Created by jiang on 2019/7/6.
//  Copyright © 2020年 tmpName. All rights reserved.
//

import UIKit

class BSUtils {
    
    static let MAX_VALUE:Double = 4.4              //最小值
    static let MIN_VALUE:Double = 10              //最大值
    
    class func getDinnerTimeName(_ time:String) -> String{
        var res = ""
        var hour:Double = -1
        let timeArr = time.components(separatedBy: " ")
        if timeArr.count > 1{
            let numberArr = timeArr[1].components(separatedBy: ":")
            let hourStr = "\(numberArr[0]).\(numberArr[1])" //
            hour = Double(hourStr)!
        }
        
        switch hour {
        case 0...8.30 :
            res = "空腹"
        case 8.31...11 :
            res = "早餐后"
        case 11.01...12 :
            res = "午餐前"
        case 12.01...16 :
            res = "午餐后"
        case 16.01...18 :
            res = "晚餐前"
        case 18.01...21:
            res = "晚餐后"
        case 21.01...23.59:
            res = "睡前"
            
        default:
            break
        }
        return res
    }
    
    class func getAfterDinnerNameByCode(_ code:String) -> String{
        var res = ""
        switch code {
        case "1":
            res = "空腹"
        case "2":
            res = "早餐后"
        case "3":
            res = "午餐前"
        case "4":
            res = "午餐后"
        case "5":
            res = "晚餐前"
        case "6":
            res = "晚餐后"
        case "7":
            res = "睡前"
            
        default:
            break
        }
        return res
    }
    
    //-1：未设置   1：餐后   0：餐前    2：睡前 3:空腹
    class func getDinnerTimeCode(_ time:String) -> Int{
        var res = -1
        var hour:Double = -1
        let timeArr = time.components(separatedBy: " ")
        if timeArr.count > 1{
            let numberArr = timeArr[1].components(separatedBy: ":")
            let hourStr = "\(numberArr[0]).\(numberArr[1])" //
            hour = Double(hourStr)!
        }
        
        switch hour {
        case 0...8.30 :
            res = 3
        case 8.31...11 :
            res = 1
        case 11.01...12 :
            res = 0
        case 12.01...16 :
            res = 1
        case 16.01...18 :
            res = 0
        case 18.01...21:
            res = 1
        case 21.01...23.59:
            res = 2
        default:
            break
        }
        return res
    }
    
    /**
     判断血糖指标层次 （餐前：4.4-10    餐后：4.4-10    睡前：4.8-10  空腹：4.4-8.0）
     
     - parameter value: 血糖值，已除以18
     - parameter kind:  -1：未设置   1：餐后   0：餐前    2：睡前   3:空腹
     
     - returns: 1：低   2：正常   3：高
     */
    class func getBloodSugarLevel(_ value:Double,kind:String) -> Int{
        var res = -1
        
        switch kind {
        case "-1":  //未设置
            res = -1
            
        case "0","1":   //餐前  餐后
            if value > 10{
                res = 3
            }
            else if value >= 4.4 && value <= 10{
                res = 2
            }
            else{
                res = 1
            }
        case "2":   //睡前
            if value > 10{
                res = 3
            }
            else if value >= 4.8 && value <= 10{
                res = 2
            }
            else{
                res = 1
            }
        case "3":   //空腹
            if value > 8.0{
                res = 3
            }
            else if value >= 4.4 && value <= 8.0{
                res = 2
            }
            else{
                res = 1
            }
            
        default:
            break
        }
        
        return res
    }
    
    /**
     判断血糖指标颜色 （餐前：4.4-7    餐后：<10    睡前：4.8-7.8）
     
     - parameter value: 血糖值，已除以18
     - parameter kind:  -1：未设置   1：餐后   0：餐前    2：睡前  3:空腹
     
     - returns: 黄：低   绿：正常/未设置   红：高
     */
    class func getBloodSugarColor(_ value:Double,kind:String) -> UIColor{
        var res = UIUtils.getDarkGreenColor()
        let level = getBloodSugarLevel(value, kind: kind)
        switch level {
        case -1:
            res = UIUtils.getDarkGreenColor()
            
        case 1:
            res = UIUtils.getOrangeColor()
            
        case 2:
            res = UIUtils.getDarkGreenColor()
            
        case 3:
            res = UIColor.red
            
        default:
            break
        }
        return res
    }
    
    /**
     血糖指示色
     优先使用Code判断
     早餐前 = 1,// 0~8
     早餐后 = 2,//8~10
     午餐前 = 3,//10~12
     午餐后 = 4,//12~14
     晚餐前 = 5,//14~18
     晚餐后 = 6,//18~20
     睡前 = 7    //20~24
     */
    class func getBSTimeColor(_ value:Double,code:String,time:String) -> UIColor{
        //kind:  -1：未设置   1：餐后   0：餐前    2：睡前  3：空腹
        var kind = -1
        if !code.isEmpty {
            if code == "1"{
                kind = 3
            }
            else if code == "3" || code == "5"{
                kind = 0
            }
            else if code == "2" || code == "4" || code == "6"{
                kind = 1
            }
            else if code == "7"{
                kind = 2
            }
        }
        else{
            kind = getDinnerTimeCode(time)
        }
        
        return getBloodSugarColor(value, kind: "\(kind)")
    }
    
    

}
