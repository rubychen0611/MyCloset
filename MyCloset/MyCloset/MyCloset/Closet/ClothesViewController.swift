//
//  ClothesViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/20.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import os.log


class ClothesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{


    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let clv = self.collectionView
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        clv?.addGestureRecognizer(longPressGesture)
        self.title = subclasses[curSelectedLargeClass][curSelectedSubclass]
        
    }


    //MARK:手势响应
   
     @objc private func longPressGesture(_ recognizer:UILongPressGestureRecognizer)
     {
        let touchPoint = recognizer.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: touchPoint)
        {
            let message = "确定要删除牌子为 " + closet[curSelectedLargeClass][curSelectedSubclass][indexPath.row].brand + " 的这件衣服吗？"
            let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
            let sureAction = UIAlertAction(title: "确定", style: .destructive, handler: {
                action in
                closet[curSelectedLargeClass][curSelectedSubclass].remove(at:indexPath.row)
                self.collectionView.reloadData()
                self.saveClothes()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(sureAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
         
            
        }
  
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
            
                closet[garment.largeclass][garment.subclass].append(garment)
                collectionView.reloadData()
                
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
