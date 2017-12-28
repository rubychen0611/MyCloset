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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
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







}
