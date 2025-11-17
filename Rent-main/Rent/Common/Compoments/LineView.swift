//
//  ContextLineView.swift
//  AfterDoctor
//
//  Created by jiang on 2019/12/8.
//  Copyright © 2020年 jiang. All rights reserved.
//  ps: 此处用CGContext，另可以考虑用CGPath和UIBezierPath

import UIKit

enum LineSyle:Int {
    case normal = 0
    case dash = 1
}

enum LineDirection:Int {
    case horizontal = 0
    case vertical = 1
}

///视图顶部画线;
///frame中, width为线长 height为线宽(最大为5)
class LineView: UIView {
    fileprivate var points = [CGPoint]()
    var color = UIColor.red
    var style = LineSyle.normal
    var direction = LineDirection.horizontal
    var lineWidth:CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    func layout(){
        self.backgroundColor = UIColor.clear
        let rect = self.frame
        if self.direction == .horizontal{
            self.points = [CGPoint(x: 0, y: 0),CGPoint(x:rect.width, y:0)]  //View 顶部画横线
            self.lineWidth = rect.height
        }
        else{
            self.points = [CGPoint(x: 0, y: 0),CGPoint(x:0, y:rect.height)]  //View 左侧画竖线
            self.lineWidth = rect.width
        }
        
        if rect.height > 5{
            lineWidth = 5
        }
    }

    override func draw(_ rect: CGRect) {
        if self.points.count < 2{
            return
        }
        
        //DashLine: https://blog.csdn.net/zhouleizhao/article/details/38655761
        if let context = UIGraphicsGetCurrentContext(){
            context.setLineCap(.butt)
            context.setLineWidth(lineWidth) //线宽
            if self.style == .dash{
                //lengths:[线长，空长，线长...]循环执行； phase:第一个线段与起点相隔距离
                if lineWidth > 5{
                    context.setLineDash(phase: 3, lengths: [lineWidth])
                }
                else{
                    context.setLineDash(phase: 3, lengths: [3])
                }
            }
            context.setAllowsAntialiasing(true)
            context.setStrokeColor(self.color.cgColor)  //线的颜色
            context.beginPath()
            context.move(to: self.points.first!)    //起点坐标
            for point in self.points{
                context.addLine(to: point)  //下一个点坐标
            }
            context.strokePath()
        }
    }

}
