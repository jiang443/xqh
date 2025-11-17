//
//  ThreadUtils.swift
//  Rent
//
//  Created by jiang on 19/3/14.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
class ThreadUtils {
    
    fileprivate static var Async :DispatchQueue = DispatchQueue(label: "tmpName_async", attributes: DispatchQueue.Attributes.concurrent)
    fileprivate static var AsyncDBQueue :DispatchQueue = DispatchQueue(label: "tmpName_db_queue", attributes: [])
    fileprivate static var AsyncHttpQueue :DispatchQueue = DispatchQueue(label: "tmpName_http_queue", attributes: [])
    fileprivate static var AsyncUploadImgQueue :DispatchQueue = DispatchQueue(label: "tmpName_upload_img_queue", attributes: [])
    
    static func threadOnMain(_ block:@escaping (() -> Void)){
        DispatchQueue.main.async(execute: block)
    }
    
    static func threadOnAsync(_ block:@escaping (() -> Void)){
        Async.async(execute: block)
    }
    
    static func threadOnDBQueue(_ block:@escaping (() -> Void)){
        AsyncDBQueue.async(execute: block)
    }
    
    //毫秒
    static func threadOnAsyncAfter(_ time:UInt64,block:@escaping (() -> Void)){
        Async.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(time * NSEC_PER_MSEC)) / Double(NSEC_PER_SEC), execute: block)
    }
    
    static func threadOnHttpQueue(_ block:@escaping (() -> Void)){
        AsyncHttpQueue.async(execute: block)
    }
    
    static func threadOnUploadImgQueue(_ block:@escaping (() -> Void)){
        AsyncUploadImgQueue.async(execute: block)
    }
    
    static func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
