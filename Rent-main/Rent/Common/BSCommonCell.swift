//
//  BSCommonCell.swift
//  Rent
//
//  Created by jiang 2019/3/21.
//  Copyright © 2019年 jiang. All rights reserved.
//

import UIKit

class BSCommonCell: UITableViewCell {

    lazy var titlelabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
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
        self.contentView.addSubview(self.titlelabel)
        self.titlelabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(self.rightLabel)
        self.rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.left.greaterThanOrEqualTo(titlelabel.snp.right)
            make.centerY.equalToSuperview()
        }
    }
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
}

