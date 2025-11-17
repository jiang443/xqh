//
//  ScreenMaskView.swift
//  BSMDoctor
//
//  Created by jiang on 2018/12/26.
//  Copyright © 2018年 jiang. All rights reserved.
//

import UIKit

public class ScreenMaskView: UIView,UIGestureRecognizerDelegate {

    public var onTap:(() -> Void)?
    
    public var onDismiss:(() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    func layout(){
        let rect = UIScreen.main.bounds
        self.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTap))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    public func show(_ completion:(() -> Void)?){
        UIApplication.shared.keyWindow?.endEditing(true)
        UIApplication.shared.keyWindow?.addSubview(self)
        completion?()
    }
    
    public func dismiss(_ completion:(() -> Void)?){
        completion?()
        self.onDismiss?()
        self.removeFromSuperview()
    }
    
    @objc func userTap(){
        self.dismiss(nil)
        self.onTap?()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is ScreenMaskView{
            return true
        }
        return false
    }
   
}
