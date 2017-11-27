//
//  NewGarmentViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/11/25.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class NewGarmentViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    //MARK: Proporties
    private let lefttypes = 0
    private let righttypes = 1
    private var curLeft = ""
    private var curRight = ""
    private var curLeftRow = 0
    private var curRightRow = 0
    private let clothestypes = ["上衣","下装","外套","连衣裙","鞋子","包","配饰"]
    private let smalltypes = [["短袖", "T袖", "衬衫", "卫衣", "马甲", "其他上衣"],
                              ["牛仔裤","短裤","运动裤","七分裤","阔腿裤","半裙","长裙","其他下装"],
                              ["夹克", "风衣", "大衣", "羽绒服", "棉袄", "棒球服", "其他外套"],
                              ["短连衣裙", "长连衣裙", "其他连衣裙"],
                              ["运动鞋", "板鞋", "休闲鞋", "靴子", "凉鞋", "皮鞋", "其他鞋子"],
                              ["双肩包", "单肩包", "钱包", "旅行箱", "肩挎包", "其他包"],
                              ["帽子", "围巾", "腰带", "手套", "袜子", "头饰", "其他配饰"]]
    
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
        self.GarmentClassification.setTitle("请选择分类", for:UIControlState.normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func OnClassificationButtonPressed(_ sender: UIButton) //设置季节按钮动作
    {
        let ClassificationPickerSheet = UIAlertController(title:"\n\n\n\n\n\n\n\n\n\n",message: nil, preferredStyle:.actionSheet)
        let doublePicker = UIPickerView()
        doublePicker.delegate = self
        doublePicker.dataSource = self
        //curLeftRow = doublePicker.selectedRow(inComponent: lefttypes)
        //curRightRow = doublePicker.selectedRow(inComponent:righttypes)
        //let left = clothestypes[curLeftRow]
        //let right = smalltypes[curLeftRow][curRightRow]
        
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
            return clothestypes.count
        }
        else
        {
            return smalltypes[curLeftRow].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row :Int, forComponent component: Int) -> String? //每一条目内容
    {
        if component == lefttypes
        {
            return clothestypes[row]
        }
        else
        {
            return smalltypes[curLeftRow][row]
        }
    }
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     {
        if component == lefttypes
        {
            curLeftRow = row
            pickerView.reloadComponent(righttypes)
        }
        curLeft = clothestypes[curLeftRow]
        curRight = smalltypes[curLeftRow][curRightRow]
        
    }
    
}

