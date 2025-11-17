//
//  BaseStroe.swift
//  Rent
//
//  Created by jiang on 19/3/15.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import Foundation
import SQLite

public class BaseStore {
    var isLogin = false
    
    public func getDB()->Connection{
        return DaoHelper.getInstance().db!
    }
}
