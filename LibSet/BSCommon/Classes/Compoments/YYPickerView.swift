//
//  YYPickerView.swift
//  AfterDoctor
//
//  Created by jiang on 2018/9/25.
//  Copyright © 2018年 tmpName. All rights reserved.
//

import Foundation

public protocol YYPickerViewDelegate {
    func pickerViewDidCancel(pickerView:YYPickerView)
    func pickerViewDidFinish(pickerView:YYPickerView)
    func pickerViewDidChanged(pickerView:YYPickerView, values: [String], changedValueIndex:Int)
}

public class YYPickerView:UIView,UIPickerViewDelegate,UIPickerViewDataSource{
    var rect = CGRect.zero
    let valueLabel = UILabel()
    var delegate:YYPickerViewDelegate?
    var pickerView = UIPickerView()
    var identifier = ""
    var selectedIndex = 0
    var selectionArrays = [[String]](){
        didSet{
            pickerView.reloadAllComponents()    //refresh
            valueArray.removeAll()
            for itemArr in selectionArrays{
                if itemArr.count > 0{
                    valueArray.append(itemArr[0])
                }
            }
            self.valueLabel.text = getValuesText()
        }
    }
    var valueArray = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layout(){
        let screenBounds = UIScreen.main.bounds
        rect = CGRect(x: 0, y: 0, width: screenBounds.width, height: 220)
        self.frame = rect
        self.backgroundColor = UIUtils.getBackgroundColor()
        self.layer.zPosition = 9999
        
        let backView = UIView()
        backView.frame = CGRect(x: 0, y: 35, width: rect.width, height: rect.height-35)
        backView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        backView.layer.zPosition = -100
        self.addSubview(backView)
        
        valueLabel.frame = CGRect(x: 0, y: 0, width: rect.width*0.6, height: 30)
        valueLabel.center = CGPoint(x: rect.width/2, y: 20)
        valueLabel.font = UIFont.systemFont(ofSize: 17)
        valueLabel.textColor = UIColor.darkGray
        valueLabel.textAlignment = .center
        valueLabel.text = "请选择"
        self.addSubview(valueLabel)
        
        let cancelButton = UIButton(frame: CGRect(x: 10,y: 5,width: 60,height: 30))
        cancelButton.setTitle("取消", for:.normal)
        cancelButton.setTitleColor(UIColor.darkGray, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.addTarget(self, action: #selector(didCancel), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        let okButton = UIButton(frame: CGRect(x: rect.width-70,y: 5,width: 60,height: 30))
        okButton.setTitle("确定", for:.normal)
        okButton.setTitleColor(UIColor.darkGray, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        okButton.addTarget(self, action: #selector(didFinish), for: .touchUpInside)
        self.addSubview(okButton)
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 30, width: screenBounds.width, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addSubview(pickerView)
        pickerView.reloadAllComponents()    //刷新UIPickerView
        
    }
    
    //列数
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return selectionArrays.count
    }
    
    //指定列的行数
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return selectionArrays[component].count
    }
    
    //返回指定列，行的高度，就是自定义行的高度
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (pickerView.frame.height - 30) / 5
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.frame.width/CGFloat(selectionArrays.count)
        if selectionArrays.count == 1{
            return width * 0.8
        }
        return width > 120 ? 120 : width
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var contentView = view
        if contentView == nil{
            contentView = UIView()
        }
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 17)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        textLabel.text = selectionArrays[component][row]
        contentView?.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView!)
        }
        return contentView!
    }
    
    //显示的标题
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectionArrays[component][row]
    }
    
    //被选择的行
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = selectionArrays[component][row]
        valueArray[component] = selectedValue
        self.valueLabel.text = getValuesText()
        self.selectedIndex = row
        self.delegate?.pickerViewDidChanged(pickerView:self, values: valueArray, changedValueIndex: component )
    }
    
    @objc func didCancel(){
        self.delegate?.pickerViewDidCancel(pickerView: self)
    }
    
    @objc func didFinish(){
        self.delegate?.pickerViewDidFinish(pickerView: self)
        self.delegate?.pickerViewDidChanged(pickerView: self, values: valueArray, changedValueIndex: 0)
    }
    
    func getValuesText() -> String{
        var valueText = ""
        for item in valueArray{
            valueText = valueText + " " + item
        }
        return valueText
    }
    
    func getCountArray(start:Int, end:Int) -> [String]{
        return getCountArray(start: start, end: end, beforeNum: "", afterNum: "")
    }
    
    func getCountArray(start:Int, end:Int, beforeNum:String, afterNum:String) -> [String]{
        var resArr = [String]()
        if start > end{
            return resArr
        }
        for index in start...end{
            resArr.append("\(beforeNum)\(index)\(afterNum)")
        }
        return resArr
    }
    
    
}
