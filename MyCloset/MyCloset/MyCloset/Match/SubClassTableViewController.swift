//
//  SubClassTableViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/5.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class SubClassTableViewController: UITableViewController {

    let SubclassTableIdentifier = "SubclassTableIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return subclasses[curSelectedLargeClass_Match].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SubclassTableIdentifier)
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:SubclassTableIdentifier)
        }
        cell?.textLabel?.text = subclasses[curSelectedLargeClass_Match][indexPath.row]
        cell?.backgroundColor = UIColor.clear//背景色透明
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) //点击tableview某行后的动作
    {
        curSelectedSubclass_Match = indexPath.row
    }
   


}
