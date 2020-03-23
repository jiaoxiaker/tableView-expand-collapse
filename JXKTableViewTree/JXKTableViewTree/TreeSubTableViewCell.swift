//
//  TreeSubTableViewCell.swift
//  JXKTableViewTree
//
//  Created by justforYOU on 2020/3/10.
//  Copyright © 2020 jiaoxiaker. All rights reserved.
//

import UIKit

class TreeSubTableViewCell: UITableViewCell {

    var SubImgIcon: UIImageView?
    var SubTitleLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 界面设置
extension TreeSubTableViewCell {
    func setupUI() {
        SubImgIcon = UIImageView(frame: CGRect(x: 13, y: 0, width: 19, height: 60))
        self.contentView.addSubview(SubImgIcon!)
        
        SubTitleLabel = UILabel(frame: CGRect(x: 45, y: 8, width: 183, height: 21))
        SubTitleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(SubTitleLabel!)
    }
}
