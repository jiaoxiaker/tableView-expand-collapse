//
//  ViewController.swift
//  JXKTableViewTree
//
//  Created by justforYOU on 2020/3/6.
//  Copyright © 2020 jiaoxiaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - 定义属性
    var dataSource = [FratherModel]()
    var tableView: UITableView!
    var sectionIsOpen: Array = [String]()
    var subCellDic: Dictionary<String, TreeModel> = [:]
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initConfiguration()
        self.setupUI()
    }


}


// MARK: - 界面设置
extension ViewController {
    func setupUI() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource
extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIsOpen: Bool = (self.sectionIsOpen[section] as NSString).boolValue
        if sectionIsOpen {
            let sectionDic = self.dataSource[section]
            let sons = sectionDic.sub
            return sons?.count ?? 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionDic = self.dataSource[indexPath.section]
        let cellData = sectionDic.sub?[indexPath.row]
        let subCell = self.subCellDic[(cellData?.chapterID)!]
        if subCell!.cellIsOpen! {
            if let subData = subCell?.subData {
                return CGFloat(60*(subData.count + 1))
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TreeTableViewCell.init(style: .default, reuseIdentifier: "CellIdentifier")
        cell.contentView.backgroundColor = UIColor.white
        let sectionDic = self.dataSource[indexPath.section]
        if let cellAry = sectionDic.sub
        {
            let cellData = cellAry[indexPath.row]
            cell.titleLabel?.text = cellData.chapterName
            let subCellData = cellData.sub
            let chapterID =  cellData.chapterID!
            let model = self.subCellDic[chapterID]!
            cell.configureCellDataWithModel(model: model)
            if indexPath.row == cellAry.count - 1 {
                if  subCellData?.count != nil {
                    if model.cellIsOpen! {
                        cell.imgIcon?.image = UIImage(named: "三级圆环减")
                    }else{
                        cell.imgIcon?.image = UIImage(named: "二级圆环-尾加")
                    }
                }else{
                    cell.imgIcon?.image = UIImage(named: "二级圆尾")
                }
            }else {
                if  subCellData?.count != nil {
                    if model.cellIsOpen! {
                        cell.imgIcon?.image = UIImage(named: "三级圆环减")
                    }else{
                        cell.imgIcon?.image = UIImage(named: "二级加号")
                    } 
                }else{
                    cell.imgIcon?.image = UIImage(named: "zhongjian")
                }
            }
            if model.cellIsOpen! {
                cell.showTableView()
            }else {
                cell.hiddenTableView()
            }
            cell.backgroundView = UIView.init(frame: cell.frame)
        }
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let treeHeaderView = TreeHeaderView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 60))
        let sectionDic = self.dataSource[section]
        treeHeaderView.titleLabel?.text = sectionDic.chapterName
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.25))
        lineView.backgroundColor = RGBAlpa(204, 204, 204, 1)
        treeHeaderView.addSubview(lineView)
        
        let sectionIsOpen: Bool = (self.sectionIsOpen[section] as NSString).boolValue
        if sectionIsOpen {
            if sectionDic.sub != nil {
                treeHeaderView.imgIcon?.image = UIImage(named: "一级减号")
                treeHeaderView.imgIcon?.contentMode = .top
            }else{
                treeHeaderView.imgIcon?.image = UIImage(named: "一级圆")
                treeHeaderView.imgIcon?.contentMode = .top
            }
        }else {
            if sectionDic.sub != nil {
                treeHeaderView.imgIcon?.image = UIImage(named: "一级圆环加号")
                treeHeaderView.imgIcon?.contentMode = .top
            }else{
                treeHeaderView.imgIcon?.image = UIImage(named: "一级圆")
                treeHeaderView.imgIcon?.contentMode = .top
            }
        }
        
        treeHeaderView.openBtn?.addTarget(self, action: #selector(sectionAction(btn:)), for: .touchUpInside)
        treeHeaderView.openBtn?.tag = section
        
        return treeHeaderView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let sectionDic = self.dataSource[indexPath.section]
        if let cellAry = sectionDic.sub
        {
            let cellData = cellAry[indexPath.row]
            let subCell = self.subCellDic[cellData.chapterID!]
            if let sub = subCell {
                sub.cellIsOpen = !sub.cellIsOpen!
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    @objc func sectionAction(btn: UIButton) {
        let sectionIsOpen: Bool = (self.sectionIsOpen[btn.tag] as NSString).boolValue
        let sectionStatus: Bool = !sectionIsOpen
        self.sectionIsOpen[btn.tag] = NSNumber(value: sectionStatus).stringValue
        self.tableView.reloadSections(NSIndexSet(index: btn.tag) as IndexSet , with: .automatic)
    }
}


// MARK: - 初始化配置
extension ViewController {
    func initConfiguration() {
        let filePath = Bundle.main.path(forResource: "json", ofType: nil)
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath!), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
            let data = try JSONSerialization.data(withJSONObject: jsonResult, options: [])
            let jsonDecoder = JSONDecoder()
            self.dataSource = try! jsonDecoder.decode([FratherModel].self, from: data)
            for _ in 0..<self.dataSource.count {
                self.sectionIsOpen.append("0")
            }
            
            //subCell
            for sub in self.dataSource {
                let son: [SonClasses] = sub.sub ?? []
                for subCell in son {
                    let model = TreeModel()
                    model.subData = subCell.sub
                    model.cellIsOpen = false
                    self.subCellDic.updateValue(model, forKey: subCell.chapterID!)
                }
            }
        
        } catch let error {
            print("读取本地数据出现错误!",error)
        }
        
    }
}


// MARK: - Model对象
/*"chapterID": "1103",
"chapterName": "必修五",
"sub": [
    {
    "chapterID": "1104",
    "chapterName": "第一单元",
    "sub": [
        {
        "chapterID": "1105",
        "chapterName": "1、沁园春 长沙"*/
struct FratherModel: Codable {
    var chapterID: String?
    var chapterName: String?
    var sub: [SonClasses]?
}

struct SonClasses: Codable {
    var chapterID: String?
    var chapterName: String?
    var sub: [GrandSonClasses]?
}

struct GrandSonClasses: Codable {
    var chapterID: String?
    var chapterName: String?
}
