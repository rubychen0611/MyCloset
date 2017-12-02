//
//  NewGarmentViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/25.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import os.log
class NewGarmentViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK: Properties
    var garment: Garment?
    private let lefttypes = 0
    private let righttypes = 1
    private var curLeft = ""
    private var curRight = ""
    private var curLeftRow = 0
    private var curRightRow = 0
    private var curDate: Date? = nil
    
    @IBOutlet weak var SaveButton: UIBarButtonItem!
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
        if let garment = garment
        {
            SaveButton.isEnabled = true
            GarmentImage.image = garment.photo
            GarmentClassification.setTitle("\(largeclasses[garment.largeclass])>\(subclasses[garment.largeclass][garment.subclass])",for: UIControlState.normal)
            switch(garment.season)
            {
                case .any: GarmentSeason.setTitle("任意", for:UIControlState.normal)
                case .springautumn: GarmentSeason.setTitle("春秋", for:UIControlState.normal)
                case .summer: GarmentSeason.setTitle("夏", for:UIControlState.normal)
                case .winter: GarmentSeason.setTitle("冬 ", for:UIControlState.normal)
            }
            self.GarmentBrand.text = garment.brand
            self.GarmentPrice.text = garment.price
            if(garment.boughtdate != nil)
            {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current // 设置时区
            dateFormatter.dateFormat = "YYYY年MM月dd日"
        self.GarmentBoughtDate.setTitle(dateFormatter.string(from: garment.boughtdate!), for:.normal)
            }
            else
            {
                self.GarmentBoughtDate.setTitle("请选择购买日期",for: UIControlState.normal)
            }
            GarmentExtraInfo.text = garment.extrainfo
        }
        else
        {
            SaveButton.isEnabled = false
            self.GarmentSeason.setTitle("任意", for: UIControlState.normal)
            self.GarmentBoughtDate.setTitle("请选择购买日期",for: UIControlState.normal)
            self.GarmentClassification.setTitle("\(largeclasses[curSelectedLargeClass])>\(subclasses[curSelectedLargeClass][curSelectedSubclass])", for:UIControlState.normal)
        }
        
        self.GarmentBrand.delegate = self
        self.GarmentPrice.delegate = self
        self.GarmentExtraInfo.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === SaveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let photo = GarmentImage.image
        let largeclass = curLeftRow
        let subclass = curRightRow
        var season: Season
        switch (GarmentSeason.currentTitle)
        {
        case "任意"?: season = .any
        case "春秋"?: season = .springautumn
        case "夏"?: season = .summer
        case "冬"?: season = .winter
        default: season = .any
        }
        let brand = GarmentBrand.text ?? ""
        let price = GarmentPrice.text ?? ""
        let boughtdate = curDate
        let extrainfo = GarmentExtraInfo.text ?? ""
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        garment = Garment(photo: photo!, largeclass:largeclass, subclass: subclass, season: season, brand: brand, price : price, boughtdate: boughtdate, extrainfo: extrainfo)
    }
    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
       // print(presentingViewController)
       // print("deinit: \(NSStringFromClass(type(of: self.presentingViewController) as! AnyClass))")
        let pvc = presentingViewController
        let isPresentingInAddGarmentMode = presentingViewController is UINavigationController //判断是否正添加新衣服
        
       if isPresentingInAddGarmentMode
        {
            dismiss(animated: true, completion: nil)
        }
        else
        if let owningNavigationController = navigationController
        {
           owningNavigationController.popViewController(animated: true)
        }
        else
        {
            fatalError("The NegGarmentViewController is not inside a navigation controller.")
        }
    }
    
    /*解决键盘遮挡输入框问题*/
    @IBAction func endEdit(_ sender: UITextField)
    {
         animateViewMoving(up: false, moveValue: 100)
    }
    @IBAction func beginEdit(_ sender: UITextField)
    {
        animateViewMoving(up: true, moveValue: 100)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    @IBAction func OnClassificationButtonPressed(_ sender: UIButton) //设置分类按钮动作
    {
        let ClassificationPickerSheet = UIAlertController(title:"\n\n\n\n\n\n\n\n\n\n",message: nil, preferredStyle:.actionSheet)
        let doublePicker = UIPickerView()
        doublePicker.delegate = self
        doublePicker.dataSource = self
        curLeftRow = doublePicker.selectedRow(inComponent: lefttypes)
        curRightRow = doublePicker.selectedRow(inComponent:righttypes)
        curLeft = largeclasses[curLeftRow]
        curRight = subclasses[curLeftRow][curRightRow]
        
        let SelectClassification = UIAlertAction(title: "选择分类", style: UIAlertActionStyle.default, handler: {action in
            self.GarmentClassification.setTitle("\(self.curLeft) > \(self.curRight)", for:UIControlState.normal)})
        
        ClassificationPickerSheet.addAction(SelectClassification)
        let Cancel = UIAlertAction(title:"取消",style :.cancel, handler: nil)
        ClassificationPickerSheet.addAction(Cancel)
        ClassificationPickerSheet.view.addSubview(doublePicker)
        present(ClassificationPickerSheet, animated: true, completion: nil)
        
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) //从相册选择图片
    {
        // Hide the keyboard.
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
        let AnySeason = UIAlertAction(title: "任意", style: .default, handler: {action in self.GarmentSeason.setTitle("任意", for: UIControlState.normal)})
        let SpringAutumn = UIAlertAction(title:"春秋",style: .default, handler:{action in self.GarmentSeason.setTitle("春秋", for: UIControlState.normal)})
        let Summer = UIAlertAction(title:"夏",style: .default, handler:{action in self.GarmentSeason.setTitle("夏", for: UIControlState.normal)})
        let Winter = UIAlertAction(title:"冬",style: .default, handler:{action in self.GarmentSeason.setTitle("冬", for: UIControlState.normal)})
        let Cancel = UIAlertAction(title:"取消",style :.cancel, handler: nil)
        SeasonPicker.addAction(AnySeason)
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
            self.GarmentBoughtDate.setTitle(dateFormatter.string(from: DatePicker.date), for:UIControlState.normal)
            self.curDate = DatePicker.date
        })
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
       // textField.becomeFirstResponder()
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mealNameLabel.text = textField.text
        //保存用户输入信息
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //点击其他地方隐藏键盘
        view.endEditing(true)
    }
    
    //MARK: UIImagePickerController代理方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        GarmentImage.image = selectedImage
        if GarmentImage.image != #imageLiteral(resourceName: "defaultPhoto")
        {
            SaveButton.isEnabled = true
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
   
    
    //MARK: UIPickerView代理方法
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int //返回滚轮个数
    {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int //返回每个滚轮里条目数
    {
        if component == lefttypes
        {
            return largeclasses.count
        }
        else
        {
            return subclasses[curLeftRow].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row :Int, forComponent component: Int) -> String? //每一条目内容
    {
        if component == lefttypes
        {
            return largeclasses[row]
        }
        else
        {
            return subclasses[curLeftRow][row]
        }
    }
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     {
        if component == lefttypes
        {
            curLeftRow = row
            pickerView.reloadComponent(righttypes)
        }
        else
        {
            curRightRow = row
        }
        curLeft = largeclasses[curLeftRow]
        curRight = subclasses[curLeftRow][curRightRow]
        
    }
    
}

