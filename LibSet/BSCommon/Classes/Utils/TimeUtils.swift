//
//  TimeUtils.swift
//  Rent
//
//  Created by jiang on 19/3/23.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
public class TimeUtils:NSObject {
    //"yyyy-MM-dd HH:mm:ss"
    
    public static func getTimeFormat(_ format:String) -> DateFormatter{
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
    public static func localDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return date.addingTimeInterval(Double(interval))
    }
    
    /**
     本地时间戳
     */
    public static func localInterval() -> Int {
        return TimeUtils.localDate().interval()
    }
    
    /**
     utc时间->本地时间
     */
    public static func toLocalDate(_ dateStr:String,format:String) -> Date{
        let date = toDate(dateStr, format: format)
        let utcDate = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: utcDate)
        return date.addingTimeInterval(Double(interval))
    }
    
    public static func getCurrentTimeInterval()->Int{
        return Date().interval()
    }
    
    ///获取时间戳
    public static func getTimeInterval(dataStr:String, format:String)->Int{
        let date = toDate(dataStr, format: format)
        return Int(date.timeIntervalSince1970)
    }
    
    public static func getCurrentTimeString(_ format:String) ->String{
        let dateFormatter = getTimeFormat(format)
        let date = Date()
        let str = dateFormatter.string(from: date)
        return str
    }
    
    //获取13位时间戳
    public static func msCurrentTimeInterval()->Int{
        let date = Date()
        let formatter = DateFormatter() //毫秒部分，单独计算
        formatter.dateFormat = "hh:mm:ss:SSS"
        let dateStr = formatter.string(from: date)
        let msStr = dateStr.components(separatedBy: ":").last!
        let msInt = Int(msStr)!
        return Int(date.timeIntervalSince1970) * 1000 + msInt
    }
    
    //"yyyy-MM-dd HH:mm:ss"
//    static dynamic func getTimeString(_ date:Date,format:String) ->String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        let str = dateFormatter.string(from: date)
//        return str
//    }
    public static func getTimeString(_ date:Date,format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: date)
        return str
    }

    public static func getTimeStringByInterval(_ time:Int,format:String) ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let str = dateFormatter.string(from: date)
        return str
    }
    
    public static func localIntervalFromDate(_ date:Date)->Int{
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        return Int(date.timeIntervalSince1970) + interval
    }
    
    
    public static func toDateSring(_ date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: date)          // 2015-03-24 21:00:00
        return str
    }
    
    public static func toDate(_ dateStr:String,format:String) -> Date{
        let dateFormatter = getTimeFormat(format)
        if let date = dateFormatter.date(from: dateStr){
            return date
        }
        else{
            return Date()
        }
    }
    
    public static func getDaysInMonth(_ date:Date) -> Int{
        let calendar = Calendar.current
        let range = (calendar as NSCalendar).range(of: .day, in: .month, for: date)
        let days = range.length
        return days
    }
    
    /**
     获取某一时间的日期组件
     */
    public static func getDateComponents(_ date:Date) -> DateComponents{
        let calendar = Calendar.current
        let flags = [NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second,NSCalendar.Unit.weekday] as NSCalendar.Unit
        let components = (calendar as NSCalendar).components(flags, from: date)
        return components
    }
    
    /**
     获取时间差的日期组件
     */
    public static func getIntervalComponents(_ date:Date, toDate:Date) -> DateComponents{
        let flags = [NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second,NSCalendar.Unit.weekday] as NSCalendar.Unit
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let result = (gregorian as NSCalendar).components(flags, from: date, to: toDate, options: NSCalendar.Options(rawValue: 0))
        return result
    }
    
    public static func getIntervalTime(_ date:Date) -> String{
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
    
    
    public static func getChineseWeekDay(_ day:Int) -> String{
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
    
    public static func addMonth(_ myDate:Date, add:Int) -> Date{
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
    
    ///获取网络时间。
    ///isLocal:是否使用手机所在时区。
    public static func getInternetDate(isLocal:Bool, complete:@escaping (_ date:Date)->Void){
        var urlString = "http://www.baidu.com"
        urlString = (urlString as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue) ?? ""    //汉字转码
        var request = NSMutableURLRequest()
        request.url = URL(string: urlString)
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = 5
        request.httpShouldHandleCookies = false
        request.httpMethod = "GET"
        
        //var response: URLResponse?
        //try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue()) { (response, data, error) in
            if var date = (response as? HTTPURLResponse)?.allHeaderFields["Date"] as? NSString{
                date = date.substring(from: 5) as NSString
                date = date.substring(to: date.length - 4) as NSString
                let dMatter = DateFormatter()
                dMatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
                dMatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                if var netDate = dMatter.date(from: date as String)?.addingTimeInterval(60 * 60 * 8) as? Date{
                    if isLocal{
                        var zone = NSTimeZone.system as NSTimeZone
                        var interval = zone.secondsFromGMT(for: netDate)
                        var localeDate = netDate.addingTimeInterval(TimeInterval(interval))
                        complete(localeDate)
                    }
                    else{
                        complete(netDate)
                    }
                }
            }
        }
    }

}
