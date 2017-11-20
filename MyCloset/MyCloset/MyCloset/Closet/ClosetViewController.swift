//
//  ClosetViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/16.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    private var selectIndex  = 0
    private var isScrollDown = true
    private var lastOffsetY : CGFloat = 0.0
    private let clothestypes = ["上衣","下装","外套","连衣裙","鞋子","包","配饰"]
    private let smalltypes = [["短袖", "T袖", "衬衫", "卫衣", "马甲", "其他上衣"],
                              ["牛仔裤","短裤","运动裤","七分裤","阔腿裤","半裙","长裙","其他下装"],
                              ["夹克", "风衣", "大衣", "羽绒服", "棉袄", "棒球服", "其他外套"],
                              ["短连衣裙", "长连衣裙", "其他连衣裙"],
                              ["运动鞋", "板鞋", "休闲鞋", "靴子", "凉鞋", "皮鞋", "其他鞋子"],
                              ["双肩包", "单肩包", "钱包", "旅行箱", "肩挎包", "其他包"],
                              ["帽子", "围巾", "腰带", "手套", "袜子", "头饰", "其他配饰"]]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectIndex = indexPath.row
        //print(selectIndex)
        // 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
        //scrollToTop(section: selectIndex, animated: true)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: selectIndex), at: .top, animated: true)
        tableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)
        //print(currentCellIndex)
    }
    
    //MARK: - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    fileprivate func scrollToTop(section: Int, animated: Bool) {
        let headerRect = frameForHeader(section: section)
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(topOfHeader, animated: animated)
    }
    
    fileprivate func frameForHeader(section: Int) -> CGRect {
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        guard let frameForFirstCell = attributes?.frame else {
            return .zero
        }
        return frameForFirstCell;
    }
    
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
        cell?.textLabel?.textAlignment = NSTextAlignment.center //居中显示
        return cell!
    }
    
    //MARK: Collection View 代理方法
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return clothestypes.count //Section个数
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return smalltypes[section].count //Section中Item的个数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosetCollectionViewCell", for: indexPath) as! ContentCell
        cell.imageView.image = UIImage(named: "defaultPhoto.png")
        cell.label.text = smalltypes[indexPath.section][indexPath.row]
        return cell
    }
    //返回头、尾区实例
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var reuseIdentifier : String?
        if kind == UICollectionElementKindSectionHeader {
            reuseIdentifier = "CollectionReusableView"//kCollectionViewHeaderView
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier!, for: indexPath) as! ClosetCollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader {
            //let model = dataSource[indexPath.section]
           // view.setDatas(model)
            view.label.text = clothestypes[indexPath.section]
        }
        return view
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 30)
    }*/
    
    // CollectionView 分区标题即将展示
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        // 当前 CollectionView 滚动的方向向上，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
        if !isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            selectRow(index: indexPath.section)
        }
    }
    
    // CollectionView 分区标题展示结束
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        // 当前 CollectionView 滚动的方向向下，CollectionView 是用户拖拽而产生滚动的（主要是判断 CollectionView 是用户拖拽而滚动的，还是点击 TableView 而滚动的）
        if isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            selectRow(index: indexPath.section + 1)
        }
    }
    
    // 当拖动 CollectionView 的时候，处理 TableView
    private func selectRow(index : Int) {
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }
    
    // 标记一下 CollectionView 的滚动方向，是向上还是向下
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
        }
    }
}
