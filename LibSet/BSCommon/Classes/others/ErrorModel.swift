//
//  ErrorModel.swift
//  Alamofire
//
//  Created by jiang on 2019/5/5.
//

import Foundation

public class ErrorModel {
    
    public var code = 0
    
    public var message = ""
    
    public init(code:Int, message:String) {
        self.code = code
        self.message = message
    }

}
