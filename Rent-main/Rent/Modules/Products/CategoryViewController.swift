//
//  ProductsViewController.swift
//  Rent
//
//  Created by jiang on 2020/1/19.
//  Copyright © 2020 jiang. All rights reserved.
//

import UIKit

class CategoryViewController: BSBaseViewController {
    let cellId = "cellId"
    let itemW = (ScreenWidth * 0.73) / 3 - 2

    lazy var searchBar: UISearchBar = {
        let sbar = UISearchBar()
        sbar.placeholder = "搜索"
        sbar.backgroundColor = UIColor.white
        sbar.backgroundImage = UIImage() //去年底部横线
        return sbar
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "car"), for: .normal)
        button.backgroundColor = UIColor.white
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var typeListView: TypeListView = {
        let listView = TypeListView()
        listView.delegate = self
        return listView
    }()
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemW + 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TypeProductCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    lazy var viewModel: ProductsViewModel = {
        return ProductsViewModel()
    }()
    
    var dataSet = [CategoryModel]()
    var dataList = [CategoryModel]()
    var listIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        //dataList = [["icon":"img", "name": "大型显微镜"],["icon":"img", "name": "企业级"]]
        self.getData()
    }
    
    func getData(){
        YYHUD.showToast("加载中")
        self.viewModel.categorylist(onSuccess: { (list:[CategoryModel]) in
            YYHUD.dismiss()
            if list.count == 0{
                return
            }
            self.dataSet = list
            self.typeListView.dataList = list
            self.dataList = list[0].childList
            self.typeListView.tableView.reloadData()
            self.collectionView.reloadData()
        }) { (msg, code) in
            YYHUD.dismiss()
            YYHUD.showToast(msg)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /// serarchBar
    func setupSearchBar() {
        
    }

    /// UI
    func setupUI() {
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(60)
        }
        
        self.view.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(searchBar)
            make.left.equalTo(searchBar.snp.right)
            make.top.right.equalToSuperview()
        }
        
        self.view.addSubview(self.typeListView)
        self.typeListView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.27)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.right.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.73)
        }
    }
    
    @objc func doSearch(){
        let key = self.searchBar.text ?? ""
        let productsVc = ProductsViewController()
//        productsVc.showTopView = false
//        productsVc.typeId = self.dataSet[listIndex].id
//        productsVc.productName = key
        self.navigationController?.pushViewController(productsVc, animated: true)
    }
}

extension CategoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,TypeListDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TypeProductCell
        cell.model = self.dataList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataList[indexPath.row]
        let productsVc = ProductsViewController()
//        productsVc.showTopView = false
//        productsVc.typeId = item.id
//        productsVc.categoryName = item.categoryName
        self.navigationController?.pushViewController(productsVc, animated: true)
    }
    
    func didSelectList(index: Int){
        self.listIndex = index
        self.dataList = self.dataSet[index].childList
        self.collectionView.reloadData()
    }
    
}

