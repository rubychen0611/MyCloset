//
//  ClosetViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    private let clothestypes = ["上衣","下装","外套","鞋子","包","配饰"]
    let leftTableIdentifier = "leftTableleftTableIdentifier"
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:Table View Data Sourse Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return clothestypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.rowHeight = 70
        var cell = tableView.dequeueReusableCell(withIdentifier: leftTableIdentifier)
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:leftTableIdentifier)
        }
        cell?.textLabel?.text = clothestypes[indexPath.row]
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize:20)
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        return cell!
    }
}
