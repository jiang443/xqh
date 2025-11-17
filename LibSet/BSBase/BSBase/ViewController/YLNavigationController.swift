//
//  YLNavigationViewController.swift
//  Alamofire
//
//  Created by jiang on 2020/2/23.
//

import UIKit

open class YLNavigationController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.window?.rootViewController = self
    }


    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let vc = self.presentedViewController {
            // don't bother dismissing if the view controller being presented is a doc/image picker
            if vc.isKind(of:UIImagePickerController.self) {
                vc.dismiss(animated: true, completion: completion)
            }
            else{
                super.dismiss(animated: flag, completion:completion)
            }
        }
    }

}
