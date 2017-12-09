//
//  AddMatchViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/5.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import os.log

var curSelectedLargeClass_Match = 0
var curSelectedSubclass_Match = 0
var curSelectedImageIndex_Match = 0

class AddMatchViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var EditMatchView: BackgroundView!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

        guard let button = sender as? UIBarButtonItem, button === SaveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        EditMatchView.allBorderDisappear()
        let matchImage = EditMatchView.generateScreenShot()
        let clothes = EditMatchView.getClothes()
        let newMatch = Match(clothes: clothes, screenShot: matchImage)
        dailyMatches[CalendarViewController.selectedDate] = newMatch
    }
    
    
    @IBAction func unwindToAddMatchView(sender: UIStoryboardSegue)
    {
        if sender.source is ClothesCollectionViewController
        {
            let image = closet[curSelectedLargeClass_Match][curSelectedSubclass_Match][curSelectedImageIndex_Match].photo
            let newImageView = GarmentPhotoView(frame: CGRect(x: 0, y: 0, width:180, height: 180),image:image)
            EditMatchView.addNewPhotoView(newImageView)
        }
    }
    @IBAction func deleteCurSelectedPhotoView(sender: UIButton)
    {
        EditMatchView.deletePhotoView()
    }
}
