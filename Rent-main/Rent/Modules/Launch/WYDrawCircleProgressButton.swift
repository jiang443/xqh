//
//  WYDrawCircleProgressButton.swift
//  Rent
//
//  Created by jiang 2019/6/28.
//  Copyright © 2019 com.tmpName. All rights reserved.
//

import UIKit

class WYDrawCircleProgressButton: UIButton {

    var trackColor = UIColor.clear
    var progressColor = UIColor.clear
    var fillColor = UIColor.clear
    var lineWidth: CGFloat = 1.0
    var animationDuration: CGFloat = 3.0

    lazy var bezierPath: UIBezierPath = {
        let width = self.wy_width * 0.5
        let height = self.wy_height * 0.5
        let path = UIBezierPath.init(arcCenter: CGPoint(x: width, y: height), radius: width, startAngle: (CGFloat(-90 * Double.pi / 180.0)), endAngle: (CGFloat(270 * Double.pi / 180.0)), clockwise: true)
        return path
    }()
    
    lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.fillColor = self.fillColor.cgColor
        layer.lineWidth = self.lineWidth
        layer.strokeColor = self.trackColor.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        layer.path = self.bezierPath.cgPath
        return layer
    }()
    
    lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.lineWidth
        layer.strokeColor = self.progressColor.cgColor
        layer.strokeStart = 0.0
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval(self.animationDuration)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        layer.add(animation, forKey: nil)
        layer.path = self.bezierPath.cgPath
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgView = UIView(frame: CGRect(x: 1, y: 1, width: self.wy_width - 2, height: self.wy_height - 2))
        bgView.isUserInteractionEnabled = false
//        bgView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        bgView.backgroundColor = UIColor.clear
        bgView.layer.cornerRadius = (self.wy_width - 2) * 0.5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimationDurarion(duration: CGFloat) {
        self.animationDuration = duration
        self.layer.addSublayer(self.trackLayer)
        self.layer.addSublayer(self.progressLayer)
    }
}

extension WYDrawCircleProgressButton: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        YYLog("动画结束")
    }
}
