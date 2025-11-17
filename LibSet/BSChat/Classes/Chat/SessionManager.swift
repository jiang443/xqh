//
//  SessionManager.swift
//  Alamofire
//
//  Created by jiang on 2019/7/5.
//

import UIKit
import SwiftEventBus

class SessionManager: NSObject {
    fileprivate static let mInstance = SessionManager()
    static func getInstance() -> SessionManager{
        return mInstance
    }
    
    ///打开与某用户的对话页面
    func openSession(id:String, viewController:UIViewController){
        let session = NIMSession.init(id, type: NIMSessionType.P2P)
        if let sessionVc = ChatViewController(session:session){
            viewController.navigationController?.pushViewController(sessionVc, animated: true)
        }
        //sessionVc.session = session
    }
    
    ///打开与某用户的对话页面
    func openSession(model:ConvStateModel){
        if let currentVc = self.getCurrentVC(){
            let session = NIMSession.init(model.im.accId, type: NIMSessionType.P2P)
            //        let sessionVc = ChatViewController()
            //        sessionVc.stateModel = model
            //        sessionVc.session = session
            //        viewController.navigationController?.pushViewController(sessionVc, animated: true)
            if let sessionVc = ChatViewController(session:session){
                sessionVc.stateModel = model
                sessionVc.session = session
                currentVc.navigationController?.pushViewController(sessionVc, animated: true)
            }
        }
        else{
            print("Current Page Not Found")
        }
    }
    
    ///打开与某用户的对话页面
    func openSession(_ session:NIMSession){
        if let currentVc = self.getCurrentVC(){
            if let sessionVc = ChatViewController(session:session){
                //sessionVc.stateModel = model
                sessionVc.session = session
                currentVc.navigationController?.pushViewController(sessionVc, animated: true)
            }
        }
        else{
            print("Current Page Not Found")
        }
    }
    
    
    func getCurrentVC() -> UIViewController? {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController{
            let currentVC = self.getCurrentVCFrom(rootViewController)
            return currentVC
        }
        else{
            return nil
        }
    }
    
    func getCurrentVCFrom(_ rootVC: UIViewController) -> UIViewController? {
        var currentVC: UIViewController?
        var rootViewController = rootVC
        if rootViewController.presentedViewController != nil {
            // 视图是被presented出来的
            rootViewController = rootViewController.presentedViewController!
        }
        if (rootViewController is UITabBarController) {
            // 根视图为UITabBarController
            currentVC = self.getCurrentVCFrom((rootViewController as! UITabBarController).selectedViewController!)
        }
        else if (rootViewController is UINavigationController) {
            // 根视图为UINavigationController
            if let vc = (rootViewController as! UINavigationController).visibleViewController{
                currentVC = self.getCurrentVCFrom(vc)
            }
        }
        else {
            // 根视图为非导航类
            currentVC = rootViewController
        }
        
        return currentVC
    }

}
