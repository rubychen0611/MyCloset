//
//  NewGarmentViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/25.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class NewGarmentViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
        self.GarmentBrand.delegate = self
        self.GarmentPrice.delegate = self
        self.GarmentExtraInfo.delegate = self
        self.GarmentSeason.setTitle("请选择季节", for: UIControlState.normal)
        self.GarmentBoughtDate.setTitle("请选择购买日期",for: UIControlState.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) //从相册选择图片
    {
        // Hide the keyboard.
        print("@@@@@@@@@@")
        GarmentBrand.resignFirstResponder()
        GarmentPrice.resignFirstResponder()
        GarmentExtraInfo.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func OnSeasonButtonPressed(_ sender: UIButton) //设置季节按钮动作
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
    @IBAction func OnBoughtDateButtonPressed(_ sender: UIButton)    //设置购买日期按钮动作
    {
        let DatePickerSheet = UIAlertController(title:"\n\n\n\n\n\n\n\n\n\n",message: nil, preferredStyle:.actionSheet)
        let DatePicker = UIDatePicker()
        DatePicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        DatePicker.datePickerMode = .date
        DatePicker.date = NSDate() as Date
        let SelectDate = UIAlertAction(title: "选择日期", style: UIAlertActionStyle.default, handler: {action in
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current // 设置时区
            dateFormatter.dateFormat = "YYYY年MM月dd日"
            self.GarmentBoughtDate.setTitle(dateFormatter.string(from: DatePicker.date), for:UIControlState.normal)})
        DatePickerSheet.addAction(SelectDate)
        let Cancel = UIAlertAction(title:"取消",style :.cancel, handler: nil)
        DatePickerSheet.addAction(Cancel)
        DatePickerSheet.view.addSubview(DatePicker)
        present(DatePickerSheet, animated: true, completion: nil)
        
    }
    
    //MARK: UITextField代理方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Hide the keyboard.
        print("hide")
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mealNameLabel.text = textField.text
        //保存用户输入信息
    }
    //MARK: UIImagePickerController代理方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        GarmentImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

