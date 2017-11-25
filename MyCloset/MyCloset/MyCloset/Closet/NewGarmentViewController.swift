//
//  NewGarmentViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/25.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class NewGarmentViewController: UIViewController
{
    //MARK: Proporties
    @IBOutlet weak var GarmentImage: UIImageView!
    @IBOutlet weak var GarmentClassification: UIButton!
    @IBOutlet weak var GarmentSeason: UIButton!
    @IBOutlet weak var GarmentBrand: UITextField!
    @IBOutlet weak var GarmentPrice: UITextField!
    @IBOutlet weak var GarmentBoughtDate: UIButton!
    @IBOutlet weak var GarmentExtraInfo: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.GarmentSeason.setTitle("春秋", for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func OnSesonButtonPressed(_ sender: UIButton)
    {
        let SeasonPicker = UIAlertController(title:"季节", message:nil, preferredStyle:.actionSheet)
        let SpringAutumn = UIAlertAction(title:"春秋",style: .default, handler:{action in self.GarmentSeason.setTitle("春秋", for: UIControlState.normal)})
        let Summer = UIAlertAction(title:"夏",style: .default, handler:{action in self.GarmentSeason.setTitle("夏", for: UIControlState.normal)})
        let Winter = UIAlertAction(title:"冬",style: .default, handler:{action in self.GarmentSeason.setTitle("冬", for: UIControlState.normal)})
        let Cancel = UIAlertAction(title:"取消",style :.cancel, handler: nil)
        SeasonPicker.addAction(SpringAutumn)
        SeasonPicker.addAction(Summer)
        SeasonPicker.addAction(Winter)
        SeasonPicker.addAction(Cancel)
        present(SeasonPicker, animated:true, completion:nil)
        
    }
    @IBAction func OnBoughtDateButtonPressed(_ sender: UIButton)
    {
        let DatePickerSheet = UIAlertController(title:"买入年月",message: nil, preferredStyle:.actionSheet)
        let DatePicker = UIDatePicker()
        DatePickerSheet.view.addSubview(DatePicker)
        let Cancel = UIAlertAction(title:"取消",style :.cancel, handler: nil)
        DatePickerSheet.addAction(Cancel)
        present(DatePickerSheet, animated: true, completion: nil)
        
    }
    
}

