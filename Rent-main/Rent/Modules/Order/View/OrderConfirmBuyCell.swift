//
//  OrderConfirmBuyCell.swift
//  Rent
//
//  Created by jiang on 2021/5/18.
//  Copyright © 2021 jiang. All rights reserved.
//

import BSCommon
import FSTextView

class OrderConfirmBuyCell: UITableViewCell {
        
    var index = 0
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    // 图标
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIUtils.getDefautImage()
        return imageView
    }()
    
    // 公司
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_LARGE)
        return label
    }()
    
    // 名字
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // 套餐
    lazy var packageLabel: UILabel = {
        let label = UILabel()
        label.text = "已选套餐：”"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    
    }()
    
    // 开始时间
    lazy var unitPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "起租时间："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    // 数量
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "数量："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    
    // 留言
    lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.text = "留言："
        label.textColor = UIUtils.getThemeColor()
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    lazy var msgTextView: FSTextView = {
        let textView = FSTextView()
        textView.placeholder = "请输入留言信息"
        return textView
    }()

    
    lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layoutUI()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.backgroundColor = UIUtils.getBackgroundColor()
    }
    
    /// Layout
    func layoutUI() {
        self.contentView.addSubview(backView)
        self.backView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        
        self.backView.addSubview(self.companyLabel)
        self.companyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
        }
        
        self.backView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(companyLabel).offset(8)
            make.height.equalTo(0.5)
        }
        
        self.backView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(companyLabel).offset(50)
            make.width.height.equalTo(60)
            make.left.equalToSuperview().offset(12)
        }
        
        self.backView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(companyLabel.snp.bottom).offset(18)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.backView.addSubview(self.packageLabel)
        self.packageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.unitPriceLabel)
        self.unitPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(packageLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(unitPriceLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(0.5)
        }
        
        self.backView.addSubview(self.msgLabel)
        self.msgLabel.snp.makeConstraints { (make) in
            make.top.equalTo(amountLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.msgTextView)
        self.msgTextView.snp.makeConstraints { (make) in
            make.top.equalTo(msgLabel.snp.bottom)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(50)
        }
        
        
    }
    
    var model: OrderProductModel? {
        didSet {
            guard let item = model else {
                return
            }
            ImageUtils.display(self.iconImageView, path: item.productImg)
            self.companyLabel.text = item.companyName
            self.nameLabel.text = item.productName
            
            self.packageLabel.attributedText = StringUtils.getColoredString("已选套餐：", coloredStr: item.packageName, color: UIUtils.getThemeColor())
            self.unitPriceLabel.attributedText = StringUtils.getColoredString("单价：", coloredStr: "\(item.productBuyOutPrice)", color: UIUtils.getThemeColor())
            self.amountLabel.attributedText = StringUtils.getColoredString("数量：", coloredStr: "\(item.quantity)", color: UIUtils.getThemeColor())
        }
    }

}
