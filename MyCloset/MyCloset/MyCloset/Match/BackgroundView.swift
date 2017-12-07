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
    
    //public actions
    public func allBorderDisappear()
    {
        curSelectedPhotoView = nil
        for iv in photoViews
        {
            iv.borderDisappear()
        }
    }
    
    public func oneBorderStay(_ sender: GarmentPhotoView)
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
    public func addNewPhotoView(_ newImageView: GarmentPhotoView)
    {
        photoViews.append(newImageView)
        addSubview(newImageView)
    }
    public func deletePhotoView()
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
    
}
