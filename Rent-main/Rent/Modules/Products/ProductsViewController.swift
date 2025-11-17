//
//  SearchResultViewController.swift
//  Rent
//
//  Created by jiang on 2020/2/2.
//  Copyright © 2020 jiang. All rights reserved.
//

import BSCommon
import BSBase

class ProductsViewController: BSBaseViewController {
    let cellId = "cellId"
    let itemW = (ScreenWidth * 0.73) / 3 - 2
    var typeId = ""      //分类id
    var labelId = ""     //标签id
    var productName = ""
    var categoryName = ""
    var brandName = ""
    var dataModel = ProductListModel()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    lazy var searchBar: UISearchBar = {
        let sbar = UISearchBar()
        sbar.placeholder = "支持搜索分类、产品名称和品牌"
        sbar.backgroundColor = UIColor.white
        sbar.backgroundImage = UIImage() //去年底部横线
        return sbar
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("搜索", for: .normal)
        button.titleLabel?.font = TextFont_15
        button.backgroundColor = UIUtils.getThemeColor()
        //button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
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
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()
    
    lazy var viewModel: ProductsViewModel = {
        return ProductsViewModel()
    }()
    
    var dataList = [PrudoctModel]()
    var showTopView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.title == nil || self.title!.isEmpty{
            self.title = "搜索"
        }
        setupUI()
        //dataList = [["icon":"img", "name": "大型显微镜"],["icon":"img", "name": "企业级"]]
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    func getData() {
        YYHUD.showStatus("加载中")
        self.viewModel.productList(typeId: self.typeId,
            labelId: self.labelId,
           productName: self.productName,
           categoryName: self.categoryName,
           brandName: self.brandName,
           pageNum: self.dataModel.pageIndex,
           onSuccess: { (model: ProductListModel) in
                YYHUD.dismiss()
                if model.pagedList.count == 0{
                   return
                }
                self.dataModel = model
                self.dataList = model.pagedList
                self.collectionView.reloadData()
            }) { (msg, code) in
                YYHUD.dismiss()
                YYHUD.showToast(msg)
            }
       }

    /// UI
    func setupUI() {
        let topHeight = self.showTopView ? 60 : 0
        self.view.backgroundColor = UIUtils.getBackgroundColor()
        self.view.addSubview(topView)
        self.topView.snp.makeConstraints{ (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(topHeight)
        }
        
        self.topView.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(60)
        }
        
        self.topView.addSubview(self.searchButton)
        self.searchButton.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
            make.left.equalTo(searchBar.snp.right)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topHeight)
            make.left.right.bottom.width.equalToSuperview()
        }
    }
    
    @objc func doSearch(){
        YYHUD.showToast("search")
    }
}

extension ProductsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductCell
        cell.model = self.dataList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        YYHUD.showToast(self.searchBar.text ?? "")
        let model = self.dataList[indexPath.row]
        
        let webView = ProductDetailWebController()
        webView.url = "http://47.115.94.36:9004/apppage/productDetail?productno=\(model.productNo)"
        webView.title = model.productName
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
}


