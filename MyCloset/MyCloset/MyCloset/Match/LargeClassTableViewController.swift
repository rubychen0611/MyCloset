//
//  LargeClassTableViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/5.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit


class LargeClassTableViewController: UITableViewController {

    let LargeClassTableIdentifier = "LargeClassTableIdentifier"

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return largeclasses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: LargeClassTableIdentifier)
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:LargeClassTableIdentifier)
        }
        cell?.textLabel?.text = largeclasses[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize:20) //字体、大小
        cell?.backgroundColor = UIColor.clear//背景色透明
        cell?.textLabel?.textAlignment = NSTextAlignment.center //居中显示
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) //点击tableview某行后的动作
    {
        curSelectedLargeClass_Match = indexPath.row
    }
    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}
