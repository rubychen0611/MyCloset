//
//  ClothesCollectionViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/5.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MatchGarmentReuseIdentifier"

class ClothesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if sender is UICollectionViewCell
        {
            curSelectedImageIndex_Match = (collectionView!.indexPath(for: sender as! UICollectionViewCell)?.row)!
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return closet[curSelectedLargeClass_Match][curSelectedSubclass_Match].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MatchGarmentCollectionViewCell
    
        cell.photoImageView.image = closet[curSelectedLargeClass_Match][curSelectedSubclass_Match][indexPath.row].photo
    
        return cell
    }
  /*  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        curSelectedImageIndex_Match = indexPath.row
    }
 */
    // MARK: UICollectionViewDelegate







}
