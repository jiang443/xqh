//
//  TimeUtils.swift
//  Rent
//
//  Created by jiang on 19/3/23.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
class TimeUtils:NSObject {
    //"yyyy-MM-dd HH:mm:ss"
    
    static func getTimeFormat(_ format:String) -> DateFormatter{
        let dateFormatter = DateFormatter()
        if format.isEmpty{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        else{
            dateFormatter.dateFormat = format
        }
        return dateFormatter
    }
    
    /**
     本地时间
     */
    static func localDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }
    
    /**
     本地时间戳
     */
    static func localInterval() -> Int {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return Int(date.timeIntervalSince1970) + interval
    }
    
    /**
     utc时间->本地时间
     */
    static func toLocalDate(_ dateStr:String,format:String) -> Date{
        let date = toDate(dateStr, format: format)
        let utcDate = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: utcDate)
        return date.addingTimeInterval(Double(interval))
    }
    
    static func getCurrentTimeInterval()->Int{
        let date = Date()
        return Int(date.timeIntervalSince1970)
    }
    
    static func getCurrentTimeString(_ format:String) ->String{
        let dateFormatter = getTimeFormat(format)
        let date = Date()
        let str = dateFormatter.string(from: date)
        return str
    }
    
    //"yyyy-MM-dd HH:mm:ss"
//    static dynamic func getTimeString(_ date:Date,format:String) ->String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        let str = dateFormatter.string(from: date)
//        return str
//    }
    static func getTimeString(_ date:Date,format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: date)
        return str
    }

    static func getTimeStringByInterval(_ time:Int,format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let str = dateFormatter.string(from: date)
        return str
    }
    
    static func localIntervalFromDate(_ date:Date)->Int{
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return Int(date.timeIntervalSince1970) + interval
    }
    
    
    static func toDateSring(_ date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: date)          // 2015-03-24 21:00:00
        return str
    }
    
    static func toDate(_ dateStr:String,format:String) -> Date{
        let dateFormatter = getTimeFormat(format)
        if let date = dateFormatter.date(from: dateStr){
            return date
        }
        else{
            return Date()
        }
    }
    
    static func getDaysInMonth(_ date:Date) -> Int{
        let calendar = Calendar.current
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        let days = range.length
        return days
    }
    
    /**
     获取某一时间的日期组件
     */
    static func getDateComponents(_ date:Date) -> DateComponents{
        let calendar = Calendar.current
        let flags = [NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second,NSCalendar.Unit.weekday] as NSCalendar.Unit
        let components = (calendar as NSCalendar).components(flags, from: date)
        return components
    }
    
    /**
     获取时间差的日期组件
     */
    static func getIntervalComponents(_ date:Date, toDate:Date) -> DateComponents{
        let flags = [NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second,NSCalendar.Unit.weekday] as NSCalendar.Unit
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let result = (gregorian as NSCalendar).components(flags, from: date, to: toDate, options: NSCalendar.Options(rawValue: 0))
        return result
    }
    
    static func getIntervalTime(_ date:Date) -> String{
        let components = TimeUtils.getIntervalComponents(date, toDate:localDate())
        var timeStr = ""
        if components.year! > 0 || components.month! > 0 || components.day! > 10{
            timeStr = ""
        }
        else if components.day! > 0{
            timeStr = "\(components.day!)天前"
        }
        else if components.hour! > 0{
            timeStr = "\(components.hour!)小时前"
        }
        else {
            timeStr = "\(components.minute!)分钟前"
        }
        return timeStr
    }
    
    
    static func getChineseWeekDay(_ day:Int) -> String{
        switch day {
        case 1:
            return "周日"
        case 2:
            return "周一"
        case 3:
            return "周二"
        case 4:
            return "周三"
        case 5:
            return "周四"
        case 6:
            return "周五"
        case 7:
            return "周六"
        
        default:
            break
        }
        return ""
    }
    
    static func addMonth(_ myDate:Date, add:Int) -> Date{
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
//        let flags = [NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second,NSCalendarUnit.Weekday] as NSCalendarUnit
//        let components = calendar!.components(flags, fromDate: myDate)
        var addComps = DateComponents()
        addComps.year = 0
        addComps.month = add
        addComps.day = 0
        let newDate = (calendar as NSCalendar?)?.date(byAdding: addComps, to: myDate, options: NSCalendar.Options.matchFirst)
        return newDate!
    }
}
