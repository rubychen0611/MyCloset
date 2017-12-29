//
//  MatchCollectionViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/9.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class MatchCollectionViewController: UICollectionViewController
{

    var fmArray : [String] = []
    @IBOutlet weak var tipsLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        fmArray = [String](favouriteMatches.keys)
        collectionView?.reloadData()
    }
   

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if favouriteMatches.count == 0
        {
            tipsLabel.isHidden = false
        }
        else
        {
            tipsLabel.isHidden = true
        }
        return favouriteMatches.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        cell.matchImageView.image = favouriteMatches[fmArray[indexPath.row]]?.getScreenShot()
        cell.nameLabel.text = fmArray[indexPath.row]
    
        // Configure the cell
    
        return cell
    }

   
}
