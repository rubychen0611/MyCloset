//
//  ClosetViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    private let clothestypes = ["上衣","下装","外套","连衣裙","鞋子","包","配饰"]
    private let uppertypes = ["短袖", "T袖", "衬衫", "卫衣", "马甲", "其他上衣"]
    let leftTableIdentifier = "leftTableleftTableIdentifier"
    let rightTableIdentifier = "rightTableleftTableIdentifier"
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
    
    //MARK:Table View 代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return clothestypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.rowHeight = 70    //cell高度
        var cell = tableView.dequeueReusableCell(withIdentifier: leftTableIdentifier)
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:leftTableIdentifier)
        }
        cell?.textLabel?.text = clothestypes[indexPath.row]
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize:18) //字体、大小
        cell?.backgroundColor = UIColor.clear //背景色透明
        cell?.textLabel?.textAlignment = NSTextAlignment.center //剧中显示
        return cell!
    }
    
    //MARK: Collection View 代理方法
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1 //Section个数
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return uppertypes.count //Section中Item的个数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //var cell = collectionView.dequeueReusableCell(withIdentifier: rightTableIdentifier)
        //if(cell == nil)
        //{
            //cell = UICollectionViewCell(style:UICollectionViewCellStyle.default, reuseIdentifier:rightTableIdentifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosetCollectionViewCell", for: indexPath) as! ContentCell
       // }
        cell.imageView.image = UIImage(named: "defaultPhoto.png")
        cell.label.text = uppertypes[indexPath.row]
        
        return cell
    }
}
