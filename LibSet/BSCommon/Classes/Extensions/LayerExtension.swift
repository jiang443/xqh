//
//  LayerExtension.swift
//  AfterDoctor
//
//  Created by jiang on 2019/10/10.
//  Copyright © 2017年 jiang. All rights reserved.
//

import Foundation
import UIKit


import Foundation

public extension CALayer{
    
    //解决IB中runtime attribute中layer.borderColor不能转换UIColor为CGColor
    
    public var borderUIColor:UIColor{
        set(color){
            self.borderColor = color.cgColor;
        }
        
        get{
            return UIColor(cgColor:self.borderColor!)
        }
    }
    
}

