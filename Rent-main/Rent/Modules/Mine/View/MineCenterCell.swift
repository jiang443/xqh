//
//  MineCollectionCell.swift
//  Rent
//
//  Created by jiang on 2020/1/18.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit

class MineCenterCell: UITableViewCell {
    let cellId = "cellId"
    let itemW = (ScreenWidth - 24) / 4 - 2
    let itemH = ((ScreenWidth - 24) * 0.56 - 30) / 2 - 1
    var index = 0
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MineItemCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: StringUtils.TITLE_FONT_SIZE)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    // 右侧标签
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = "全部订单>"
        label.textAlignment = .right
        label.font = TextFont_14
        label.textColor = UIColor.darkGray
        return label
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
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
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.backView)
        self.backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(-12)
        }
        
        self.backView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(35)
        }
        
        self.backView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.backView.addSubview(self.rightLabel)
        self.rightLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo (30)
        }
        
        self.backView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
        rightLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goDetail))
        rightLabel.addGestureRecognizer(tap)
        
    }
    
    @objc func goDetail(){
        print("detail index = \(index)")
    }

    var dataList = [[String:Any]]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
}

extension MineCenterCell: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MineItemCell
        cell.dict = self.dataList[indexPath.row]
        if self.index == 0 && indexPath.row%2 == 0{
            cell.badgeLabel.text = "1"
            cell.badgeLabel.isHidden = false
        }
        else{
            cell.badgeLabel.text = ""
            cell.badgeLabel.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        YYLog("collectionView index = \(indexPath.row)")
//        switch indexPath.row {
//        case 0: // 员工文章
//            let atricleVc = ArticleViewController()
//            self.navigationController?.pushViewController(atricleVc, animated: true)
//        default:
//            break
//        }
    }
    
}

