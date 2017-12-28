//
//  BackgroundView.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/7.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class BackgroundView: UIView
{
    var photoViews :[GarmentPhotoView] = []
    var curSelectedPhotoView :GarmentPhotoView? = nil
    override func touchesBegan(_ touches: (Set<UITouch>!), with event: UIEvent!)
    {
        allBorderDisappear()
    }
    
    //MARK: public actions
    public func allBorderDisappear() //点击背景,所有边框隐藏
    {
        curSelectedPhotoView = nil
        for iv in photoViews
        {
            iv.borderDisappear()
        }
    }
    
    public func oneBorderStay(_ sender: GarmentPhotoView)  //选中某张照片后，显示边框，其他照片的边框隐藏
    {
        curSelectedPhotoView = sender
        for iv in photoViews
        {
            if iv == sender
            {
                iv.drawBorder()
            }
            else
            {
                iv.borderDisappear()
            }
        }
    }
    public func addNewPhotoView(_ newImageView: GarmentPhotoView) //添加照片
    {
        photoViews.append(newImageView)
        addSubview(newImageView)
    }
    public func recommendMatchRandomly()
    {
        var tops :[Garment] = []
        var pants :[Garment] = []
        var shoes :[Garment] = []
        for i in 0 ..< largeclasses.count
        {
            for j in 0 ..< subclasses[i].count
            {
                for garment in closet[i][j]
                {
                    if(garment.largeclass == 0)
                    {
                        tops += [garment]
                    }
                    else if(garment.largeclass == 1)
                    {
                        pants += [garment]
                    }
                    else if(garment.largeclass == 4)
                    {
                        shoes += [garment]
                    }
                }
            }
        }
        let x = UIScreen.main.bounds.width / 2.0 - 90;
        var y = 0;
        if(!tops.isEmpty)
        {
            let rand:Int = Int(arc4random()) % tops.count
            let image = tops[rand].photo
            let newImageView = GarmentPhotoView(frame: CGRect(x: Int(x), y: y, width:180, height: 180),image:image)
            y += 200
            self.addNewPhotoView(newImageView)
        }
        if(!pants.isEmpty)
        {
            let rand:Int = Int(arc4random()) % pants.count
            let image = pants[rand].photo
            let newImageView = GarmentPhotoView(frame: CGRect(x: Int(x), y: y, width:180, height: 180),image:image)
            y += 200
            self.addNewPhotoView(newImageView)
        }
        if(!shoes.isEmpty)
        {
            let rand:Int = Int(arc4random()) % shoes.count
            let image = shoes[rand].photo
            let newImageView = GarmentPhotoView(frame: CGRect(x: Int(x), y: y, width:180, height: 180),image:image)
            y += 200
            self.addNewPhotoView(newImageView)
        }
        
    }
    public func deletePhotoView()   //删除照片
    {
        if let iv = curSelectedPhotoView
        {
            iv.removeFromSuperview()
            for i in 0...photoViews.count-1
            {
                if photoViews[i] == iv
                {
                    photoViews.remove(at: i)
                    break
                }
            }
        }
        
    }
    
    public func getClothes() -> [SingleGarment]
    {
        var clothes : [SingleGarment] = []
        for pv in photoViews
        {
            let image = pv.getImage()
            let location = pv.getLocation()
            let scaleFactor = pv.getScaleFactor()
            let garment = SingleGarment(image: image, location: location, scaleFactor: scaleFactor)
            clothes.append(garment)
        }
        return clothes
    }
}
extension UIView
{
    public func generateScreenShot() -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
 }
}
