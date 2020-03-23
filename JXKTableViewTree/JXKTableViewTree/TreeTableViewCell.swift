//
//  TreeTableViewCell.swift
//  JXKTableViewTree
//
//  Created by justforYOU on 2020/3/9.
//  Copyright © 2020 jiaoxiaker. All rights reserved.
//

import UIKit

class TreeTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 定义属性
    var imgIcon: UIImageView?
    var titleLabel: UILabel?
    var tableView: UITableView!
    var dataSource = [GrandSonClasses]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellDataWithModel(model: TreeModel) {
        dataSource.removeAll()
        dataSource = model.subData ?? []
        
        var frame:CGRect = self.tableView.frame
        frame.size.height = CGFloat(60 * dataSource.count)
        self.tableView.frame = frame
        self.tableView.reloadData()
    }
    
    func showTableView() {
        self.contentView.addSubview(tableView)
    }
    
    func hiddenTableView() {
        self.tableView.removeFromSuperview()
    }
}


// MARK: - 界面设置
extension TreeTableViewCell {
    func setupUI() {
        imgIcon = UIImageView(frame: CGRect(x: 13, y: -4, width: 19, height: 64))
        self.contentView.addSubview(imgIcon!)
        
        titleLabel = UILabel(frame: CGRect(x: 45, y: 8, width: 183, height: 21))
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleLabel!)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 59, width: kScreenWidth, height: 1))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(TreeSubTableViewCell.self, forCellReuseIdentifier: "SubCellID")
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension TreeTableViewCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TreeSubTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SubCellID", for: indexPath) as! TreeSubTableViewCell
        let cellData = self.dataSource[indexPath.row]
        cell.SubTitleLabel?.text = cellData.chapterName
        cell.SubImgIcon?.image = UIImage(named: "三级圆环")
        cell.SubImgIcon?.contentMode = .top
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

