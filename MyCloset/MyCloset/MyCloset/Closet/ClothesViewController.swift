//
//  ClothesViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/20.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import os.log


//var ifAddingNewGarment = false;

class ClothesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:Properties
    
   // var garment :Garment
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.title = subclasses[curSelectedLargeClass][curSelectedSubclass]
        
    }


    //MARK:CollectionView代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1 //Section个数
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closet[curSelectedLargeClass][curSelectedSubclass].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GarmentCollectionViewCell", for: indexPath) as! GarmentCollectionViewCell
        let garment = closet[curSelectedLargeClass][curSelectedSubclass][indexPath.row]
        cell.photoImageView.image = garment.photo
        return cell
    }
    
    //MARK: Private methods
    private func saveClothes()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(closet, toFile: Garment.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Clothes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save clothes...", log: OSLog.default, type: .error)
        }
    }

    //MARK: Actions
    
    @IBAction func unwindToClothesList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? NewGarmentViewController, let garment = sourceViewController.garment
        {
           
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems
            {
            if !selectedIndexPath.isEmpty
            {
                // Update an existing garment.
                closet[curSelectedLargeClass][curSelectedSubclass][selectedIndexPath[0].row] = garment
                collectionView.reloadItems(at: selectedIndexPath)
            }
            else
            {
            // Add a new garment
           // let newIndexPath = IndexPath(row: closet[garment.largeclass][garment.subclass].count, section: 0)
            
                closet[garment.largeclass][garment.subclass].append(garment)
                collectionView.reloadData()
               // collectionView.insertItems(at: [newIndexPath])
                
            }
                saveClothes()
            }
        }
    }
    
    
    //MARK:Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "")
        {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let GarmentDetailViewController = segue.destination as? NewGarmentViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGarmentCell = sender as? GarmentCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = collectionView.indexPath(for: selectedGarmentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGarment = closet[curSelectedLargeClass][curSelectedSubclass][indexPath.row]
            GarmentDetailViewController.garment = selectedGarment
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
