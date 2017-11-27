//
//  ClothesViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/20.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class ClothesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:Properties
    var clothes[Garment]()

  //  @IBOutlet weak var navigationItem :UINavigationItem!
   // @IBOutlet weak var addGarmentButton: UIBarButtonItem!
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
    

    //MARK:CollectionView代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1 //Section个数
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subclasses[curSelectedLargeClass].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }

}
