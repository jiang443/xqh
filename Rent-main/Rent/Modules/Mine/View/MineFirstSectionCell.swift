//
//  MineFirstSectionCell.swift
//  BSNurse
//
//  Created by jiang 2019/3/27.
//  Copyright © 2019年 tmpName. All rights reserved.
//

import BSCommon

class MineFirstSectionCell: UITableViewCell {
    
    var colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.getThemeColor()
        return view
    }()
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIUtils.getDefautImage()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_15
        label.textColor = TextColor_3
        label.text = "用户名"
        return label
    }()
    
    var verifyLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_12
        label.textColor = UIColor.white
        label.text = "未认证"
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_12
        label.textColor = TextColor_6
        label.text = "用户公司名称"
        label.numberOfLines = 0
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = TextColor_3
        label.text = "10086"
        return label
    }()
    
    var countTitleLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_14
        label.textAlignment = .center
        label.textColor = TextColor_6
        label.text = "余额"
        return label
    }()
    
    var markLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = TextColor_3
        label.text = "0"
        return label
    }()
    
    var markTitleLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_14
        label.textAlignment = .center
        label.textColor = TextColor_6
        label.text = "收藏"
        return label
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = TextColor_3
        label.text = "0"
        return label
    }()
    
    var carTitleLabel: UILabel = {
        let label = UILabel()
        label.font = TextFont_14
        label.textAlignment = .center
        label.textColor = TextColor_6
        label.text = "购物车"
        return label
    }()
    
    var hLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var vLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var vLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "为了你和他人的交易安全，你需先认证真实身份才能交易>"
        label.font = TextFont_12
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.color(hex: "#FA7C74")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.backgroundColor = UIUtils.getBackgroundColor()
        self.contentView.addSubview(self.colorView)
        self.contentView.addSubview(self.backView)
        self.backView.addSubview(self.iconImageView)
        self.backView.addSubview(self.nameLabel)
        self.backView.addSubview(self.infoLabel)
        self.backView.addSubview(self.verifyLabel)
        self.backView.addSubview(self.countLabel)
        self.backView.addSubview(self.countTitleLabel)
        self.backView.addSubview(self.markLabel)
        self.backView.addSubview(self.markTitleLabel)
        self.backView.addSubview(self.carLabel)
        self.backView.addSubview(self.carTitleLabel)
        self.backView.addSubview(self.hLine)
        self.backView.addSubview(self.vLine1)
        self.backView.addSubview(self.vLine2)
        self.contentView.addSubview(self.tipLabel)
        
        self.colorView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        self.backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview()
            make.height.equalTo(180)
        }
        
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(60)
            make.top.equalToSuperview().offset(20)
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-50)
            make.top.equalTo(iconImageView).offset(10)
            make.height.equalTo(20)
        }
            
        self.verifyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel)
            make.width.equalTo(45)
            make.height.equalTo(20)
        }
        
        self.infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        
        let width = (ScreenWidth - 30) / 3 - 1
        self.countLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
            make.height.equalTo(20)
            make.width.equalTo(width)
        }
        
        self.countTitleLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(countLabel)
            make.top.equalTo(countLabel.snp.bottom).offset(5)
        }
        
        self.markLabel.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(countLabel)
            make.left.equalTo(countLabel.snp.right).offset(1)
        }
        
        self.markTitleLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(markLabel)
            make.top.equalTo(markLabel.snp.bottom).offset(5)
        }
        
        self.carLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.width.height.equalTo(countLabel)
        }
        
        self.carTitleLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(carLabel)
            make.top.equalTo(carLabel.snp.bottom).offset(5)
        }
        
        self.hLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        self.vLine1.snp.makeConstraints { (make) in
            make.left.equalTo(countLabel.snp.right)
            make.top.equalTo(countLabel).offset(12)
            make.width.equalTo(0.5)
            make.height.equalTo(20)
        }
        
        self.vLine2.snp.makeConstraints { (make) in
            make.left.equalTo(markLabel.snp.right)
            make.top.equalTo(markLabel).offset(12)
            make.width.equalTo(0.5)
            make.height.equalTo(20)
        }
        
        self.tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backView.snp.bottom).offset(8)
            make.left.right.equalTo(backView)
            make.height.equalTo(30)
        }
    }
    
    var model = UserInfoModel() {
        didSet {
//            ImageUtils.display(self.iconImageView, path: model.headImg)
//            ImageUtils.display(self.iconImageView, path: model.headImg, placeholder: UIImage(named: "科主任默认头像"))
//            self.nameLabel.text = model.name
//            self.infoLabel.text = model.hospitalName + " " + model.hospitalDepartmentName
        }
    }
}
