//
//  TreeHeaderView.swift
//  JXKTableViewTree
//
//  Created by justforYOU on 2020/3/10.
//  Copyright © 2020 jiaoxiaker. All rights reserved.
//

import UIKit

class TreeHeaderView: UIView {
    // MARK: - 定义属性
    var imgIcon: UIImageView?
    var titleLabel: UILabel?
    var openBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        imgIcon = UIImageView(frame: CGRect(x: 13, y: 0, width: 19, height: 60))
        self.addSubview(imgIcon!)
        
        titleLabel = UILabel(frame: CGRect(x: self.imgIcon!.frame.maxX + 52, y: 8, width: 186, height: 21))
        self.addSubview(titleLabel!)
        
        openBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
        self.addSubview(openBtn!)
    }
    
}
