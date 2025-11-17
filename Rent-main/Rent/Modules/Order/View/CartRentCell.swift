//
//  OrderProductCell.swift
//  Rent
//
//  Created by jiang on 2020/9/12.
//  Copyright © 2020 jiang. All rights reserved.
//

import BSCommon

protocol CartRentCellDelegate {
    func deleteProduct(index: Int)
}

class CartRentCell: UITableViewCell {
    
    var delegate: CartRentCellDelegate?
    
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
    lazy var startTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "起租时间："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    // 租期
    lazy var termLabel: UILabel = {
        let label = UILabel()
        label.text = "租赁时长："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    // 月租
    lazy var rentLabel: UILabel = {
        let label = UILabel()
        label.text = "月租金："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    // 押金
    lazy var depositLabel: UILabel = {
        let label = UILabel()
        label.text = "押金："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_NORMAL)
        return label
    }()
    
    // 安装费
    lazy var assembleLabel: UILabel = {
        let label = UILabel()
        label.text = "安装费："
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
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "本单合计："
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: StringUtils.FONT_LARGE)
        return label
    }()
    
    lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIUtils.getThemeColor(), for: .normal)
        button.titleLabel?.font = TextFont_13
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIUtils.getThemeColor().cgColor
        button.layer.cornerRadius = 11
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchDelete), for: .touchUpInside)
        return button
    }()
    
    lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
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
            make.centerY.equalToSuperview().offset(-10)
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
        
        self.backView.addSubview(self.startTimeLabel)
        self.startTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(packageLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.termLabel)
        self.termLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startTimeLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.rentLabel)
        self.rentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(termLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.depositLabel)
        self.depositLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rentLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.assembleLabel)
        self.assembleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(depositLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.amountLabel)
        self.amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(assembleLabel.snp.bottom)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(0.5)
        }
        
        self.backView.addSubview(self.totalLabel)
        self.totalLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        self.backView.addSubview(self.deleteBtn)
        self.deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(totalLabel)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(22)
            make.width.equalTo(45)
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
            self.startTimeLabel.attributedText = StringUtils.getColoredString("起租时间：", coloredStr: item.startTime.components(separatedBy: " ").first ?? "", color: UIUtils.getThemeColor())
            self.termLabel.attributedText = StringUtils.getColoredString("租赁时长：", coloredStr: "\(item.rentTime)个月", color: UIUtils.getThemeColor())
            self.rentLabel.attributedText = StringUtils.getColoredString("月租金：", coloredStr: "¥\(item.monthlyRentPrice)", color: UIUtils.getThemeColor())
            self.depositLabel.attributedText = StringUtils.getColoredString("押金：", coloredStr: "¥\(item.deposit)", color: UIUtils.getThemeColor())
            self.assembleLabel.attributedText = StringUtils.getColoredString("安装费：", coloredStr: "¥\(item.mountingCost)", color: UIUtils.getThemeColor())
            self.amountLabel.attributedText = StringUtils.getColoredString("数量：", coloredStr: "\(item.quantity)", color: UIUtils.getThemeColor())
            self.totalLabel.attributedText = StringUtils.getColoredString("本单合计：", coloredStr: "¥\(item.totalPrice)", color: UIUtils.getThemeColor())
        }
    }
    
    @objc func touchDelete(){
        self.delegate?.deleteProduct(index: self.index)
    }
    
}
