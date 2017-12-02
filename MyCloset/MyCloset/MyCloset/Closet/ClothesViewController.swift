//
//  ClothesViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/20.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import os.log

var ifAddingNewGarment = false;

class ClothesViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:Properties
    var closet = Array<Array<Array<Garment>>>()
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ifAddingNewGarment = false
        
        for i in 0...largeclasses.count-1
        {
            closet.append(Array<Array<Garment>>())
            for _ in 0...subclasses[i].count-1
            {
                closet[i].append(Array<Garment>())
            }
        }
        loadSampleGarments()
        self.title = subclasses[curSelectedLargeClass][curSelectedSubclass]
        
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
        return closet[curSelectedLargeClass][curSelectedSubclass].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GarmentCollectionViewCell", for: indexPath) as! GarmentCollectionViewCell
        let garment = closet[curSelectedLargeClass][curSelectedSubclass][indexPath.row]
        cell.photoImageView.image = garment.photo
        return cell
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
            let newIndexPath = IndexPath(row: closet[curSelectedLargeClass][curSelectedSubclass].count, section: 0)
            
            closet[garment.largeclass][garment.subclass].append(garment)
                collectionView.insertItems(at: [newIndexPath])
                
            }
            }
        }
    }
    
    private func loadSampleGarments() {
        
        let photo1 = UIImage(named: "shortsleeves_1")
        let photo2 = UIImage(named: "shortsleeves_2")
        let photo3 = UIImage(named: "T-shirt_1")
        
        guard let shortsleeves_1 = Garment(photo: photo1!, largeclass: 0, subclass : 0, season: Season.summer, brand: "me&co", price: "129", boughtdate : nil, extrainfo : "") else {
            fatalError("Unable to instantiate shortsleeves1")
        }
        
        guard let shortsleeves_2 = Garment(photo: photo2!, largeclass: 0, subclass : 0, season: Season.summer, brand: "peacebird", price: "199", boughtdate : nil, extrainfo : "") else {
            fatalError("Unable to instantiate shortsleeves2")
        }
            guard let T_shirt_1 = Garment(photo: photo3!, largeclass: 0, subclass : 0, season: Season.springautumn, brand: "esprit", price: "250", boughtdate : nil, extrainfo : "") else {
                fatalError("Unable to instantiate tshirt1")
        }
        
        closet[0][0].append(shortsleeves_1)
        closet[0][0].append(shortsleeves_2)
        closet[0][1].append(T_shirt_1)
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
