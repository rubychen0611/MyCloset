//
//  AddMatchViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/5.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

var curSelectedLargeClass_Match = 0
var curSelectedSubclass_Match = 0
var curSelectedImageIndex_Match = 0

class AddMatchViewController: UIViewController {
    
    //Properties
    //var photos :[GarmentPhotoView] = []
    @IBOutlet weak var EditMatchView: BackgroundView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToAddMatchView(sender: UIStoryboardSegue)
    {
        if sender.source is ClothesCollectionViewController
        {
            let image = closet[curSelectedLargeClass_Match][curSelectedSubclass_Match][curSelectedImageIndex_Match].photo
            let newImageView = GarmentPhotoView(frame: CGRect(x: 0, y: 0, width:180, height: 180),image:image)
           // photos.append(newImageView)
            EditMatchView.addNewPhotoView(newImageView)
           // EditMatchView.addSubview(newImageView)
        }
    }
    @IBAction func deleteCurSelectedPhotoView(sender: UIButton)
    {
        EditMatchView.deletePhotoView()
    }
}
