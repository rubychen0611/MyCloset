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
    @IBOutlet weak var finishEditingButton: UIBarButtonItem!
    var isEdit = false
    var touchPoint: CGPoint? = nil
   // var garment :Garment
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        isEdit = false
        let clv = self.collectionView
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        clv?.addGestureRecognizer(longPressGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        clv?.addGestureRecognizer(tapGesture)
        self.title = subclasses[curSelectedLargeClass][curSelectedSubclass]
        
    }
    @objc func deleteItem() {
        
        if let p = touchPoint
        {
        if let indexPath = self.collectionView?.indexPathForItem(at: p)
        {
            closet[curSelectedLargeClass][curSelectedSubclass].remove(at:indexPath.row)
            collectionView.reloadData()
            saveClothes()
            }
        }
    }
    @IBAction func onEditPressed(_ sender: UIBarButtonItem)
    {
        
        if isEdit == false
        {
            finishEditingButton.title = "完成"
            for cell in self.collectionView.visibleCells
            {
                let garmentCell :GarmentCollectionViewCell = cell as! GarmentCollectionViewCell
                garmentCell.removeButton.isHidden = false
                garmentCell.removeButton.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
            }
            isEdit = true
        }
        else
        {
            finishEditingButton.title = "编辑"
            for cell in self.collectionView.visibleCells
            {
                let garmentCell :GarmentCollectionViewCell = cell as! GarmentCollectionViewCell
                garmentCell.removeButton.isHidden = true
            }
            isEdit = false
        }
    }
    //MARK:手势响应
    @objc private func tapGesture(_ recognizer:UILongPressGestureRecognizer)
    {
        if recognizer.state != .ended
        {
            return
        }
        touchPoint = recognizer.location(in: self.collectionView)
        if isEdit == true
        {
            
        }
        else
        {
            if let indexPath = self.collectionView.indexPathForItem(at: touchPoint!)
            {
                let cell :GarmentCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! GarmentCollectionViewCell
                    self.performSegue(withIdentifier: "ShowDetail", sender: cell)

            
            }
        }
    }
     @objc private func longPressGesture(_ recognizer:UILongPressGestureRecognizer)
     {
        if isEdit == false
        {
            finishEditingButton.title = "完成"
            for cell in self.collectionView.visibleCells
            {
                let garmentCell :GarmentCollectionViewCell = cell as! GarmentCollectionViewCell
                garmentCell.removeButton.isHidden = false
                garmentCell.removeButton.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
            }
            isEdit = true
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
        if isEdit == false
        {
            cell.removeButton.isHidden = true
        }
        else
        {
            cell.removeButton.isHidden = false
        }
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
