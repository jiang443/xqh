//
//  GuidePageViewModel.swift
//  Rent
//
//  Created by jiang 2019/2/26.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class GuidePageViewModel: NSObject {
    // 引导页图片
//    let imageList = [UIImage(named: "direct01.jpg"),
//                     UIImage(named: "direct02.jpg"),
//                     UIImage(named: "direct03.jpg"),
//                     UIImage(named: "direct04.jpg")]
    
    var imageList: [UIImage] {
        if (UI_IS_IPHONEX || UI_IS_IPHONEXR) {
            return [UIImage(named: "guidePage01_1242x2688.jpg")!,
                    UIImage(named: "guidePage02_1242x2688.jpg")!,
                    UIImage(named: "guidePage03_1242x2688.jpg")!,
                    UIImage(named: "guidePage04_1242x2688.jpg")!]
        }
        return [UIImage(named: "guidePage01_750x1334.jpg")!,
                UIImage(named: "guidePage02_750x1334.jpg")!,
                UIImage(named: "guidePage03_750x1334.jpg")!,
                UIImage(named: "guidePage04_750x1334.jpg")!]
    }

}
