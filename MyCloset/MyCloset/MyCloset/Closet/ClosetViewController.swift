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
    var closet: [[[Garment]]] = []
   
    
    private var selectIndex  = 0
    private var isScrollDown = true
    private var lastOffsetY : CGFloat = 0.0
   
    let leftTableIdentifier = "leftTableleftTableIdentifier"
    let rightTableIdentifier = "rightTableleftTableIdentifier"
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        if let savedClothes = loadClothes()
        {
            closet = savedClothes
        }
        else
        {
            closet = Array<Array<Array<Garment>>>()
            for i in 0...largeclasses.count-1
            {
                closet.append(Array<Array<Garment>>())
                for _ in 0...subclasses[i].count-1
                {
                    closet[i].append(Array<Garment>())
                }
            }
        }
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        closet = loadClothes()!
        collectionView.reloadData()
    }
    
    //Mark: Private methods
    private func loadClothes() -> [[[Garment]]]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Garment.ArchiveURL.path) as? [[[Garment]]]
    }
    //MARK: Table View 代理方法
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int //获得tableview行数
    {
        return largeclasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell //获得tableview cell实例
    {
        tableView.rowHeight = 70    //cell高度
        var cell = tableView.dequeueReusableCell(withIdentifier: leftTableIdentifier)
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:leftTableIdentifier)
        }
        cell?.textLabel?.text = largeclasses[indexPath.row]
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize:16) //字体、大小
        cell?.backgroundColor = UIColor.clear //背景色透明
        cell?.textLabel?.textAlignment = NSTextAlignment.center //居中显示
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) //点击tableview某行后的动作
    {
        selectIndex = indexPath.row
        curSelectedLargeClass = indexPath.row
        scrollToTop(section: selectIndex, animated: true)    //collection滚动至section头部， 并解决点击TableView后 CollectionView的Header遮挡问题
        tableView.scrollToRow(at: IndexPath(row: selectIndex, section: 0), at: .top, animated: true)  //tableview滚动
    }
    
    //MARK: - 解决点击 TableView 后 CollectionView 的 Header 遮挡问题。
    private func scrollToTop(section: Int, animated: Bool) {
        let headerRect = frameForHeader(section: section)
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(topOfHeader, animated: animated) //colection view 移动
    }
    
    private func frameForHeader(section: Int) -> CGRect
    {
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        guard let frameForFirstCell = attributes?.frame else
        {
            return .zero
        }
        return frameForFirstCell;
    }
    
   
    
    //MARK: Collection View 代理方法
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return largeclasses.count //Section个数
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return subclasses[section].count //Section中Item的个数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell //返回collection view cell实例
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosetCollectionViewCell", for: indexPath) as! ContentCell
        if(!closet[indexPath.section][indexPath.row].isEmpty)
        {
            cell.imageView.image = closet[indexPath.section][indexPath.row][0].photo
        }
        else
        {
            cell.imageView.image = #imageLiteral(resourceName: "defaultPhoto")
        }
        cell.label.text = subclasses[indexPath.section][indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        curSelectedLargeClass = indexPath.section
        curSelectedSubclass = indexPath.row
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView //返回section header实例
    {
        var reuseIdentifier : String?
        if kind == UICollectionElementKindSectionHeader
        {
            reuseIdentifier = "CollectionReusableView"//kCollectionViewHeaderView
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseIdentifier!, for: indexPath) as! ClosetCollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader
        {
            //let model = dataSource[indexPath.section]
           // view.setDatas(model)
            header.label.text = largeclasses[indexPath.section]
        }
        return header
    }
    

    // CollectionView 分区标题即将展示
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
    {
        if !isScrollDown && (collectionView.isDragging || collectionView.isDecelerating)//滚动方向向上且用户正在拖拽或减速
        {
            selectRow(index: indexPath.section) //当前tableview选择改变
        }
    }
    
    // CollectionView 分区标题展示结束
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
    {
        if isScrollDown && (collectionView.isDragging || collectionView.isDecelerating) //滚动方向向下且用户正在拖拽或减速
        {
            if indexPath.section != largeclasses.count - 1
            {
                selectRow(index: indexPath.section + 1) //当前tableview选择改变
            }
        }
    }
    
    private func selectRow(index : Int)    // 当拖动 CollectionView 的时候，处理 TableView
    {
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView)  // 标记CollectionView 的滚动方向，是向上还是向下
    {
        if collectionView == scrollView
        {
            isScrollDown = lastOffsetY < scrollView.contentOffset.y
            lastOffsetY = scrollView.contentOffset.y
        }
    }
}
