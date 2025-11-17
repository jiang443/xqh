//
//  TypeListView.swift
//  Rent
//
//  Created by jiang on 2020/1/19.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit

protocol TypeListDelegate {
    func didSelectList(index: Int)
}

class TypeListView: UIView {
    
    var dataList = [CategoryModel]()
    let cellId = "cellId"
    var lineHeight:CGFloat = 50
    var selectedIndex = 0
    var delegate: TypeListDelegate?
    
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIUtils.getThemeColor()
        view.layer.zPosition = 999
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(BSCommonCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupUI()
        //dataList = [["title": "工业显微镜"],["title": "激光设备"],["title": "监测仪器"]]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI
    func setupUI() {
        self.addSubview(self.backView)
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.backView.addSubview(self.indicatorView)
        self.indicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(lineHeight/2)
            make.left.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(15)
        }
        
        self.backView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
}

extension TypeListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return lineHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BSCommonCell
        cell.titlelabel.text = dataList[indexPath.row].categoryName
        if indexPath.row == self.selectedIndex{
            cell.backgroundColor = UIColor.white
        }
        else{
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectList(index: indexPath.row)
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        let height = lineHeight * CGFloat(indexPath.row) + lineHeight/2
        UIView.animate(withDuration: 1) {
            self.indicatorView.snp.updateConstraints { (make) in
                make.centerY.equalTo(height)
            }
        }
    }
    
}

