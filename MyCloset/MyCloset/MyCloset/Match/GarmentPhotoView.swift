//
//  GarmentPhotoView.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/6.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class GarmentPhotoView: UIImageView {

    var lastLocation = CGPoint(x: 0, y: 0)
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
    
    init(frame: CGRect, image :UIImage)
    {
        super.init(frame: frame)
        self.image = image
        self.isUserInteractionEnabled = true
        // Initialization code
        
        //拖动手势
        let panGesture = UIPanGestureRecognizer(target:self, action:#selector(GarmentPhotoView.detectPan(_:)))
        self.addGestureRecognizer(panGesture)
        //捏合手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(GarmentPhotoView.detectPinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        //randomize view color
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer)
    {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: (Set<UITouch>!), with event: UIEvent!)
    {
        self.superview?.bringSubview(toFront: self) //置于最上层
        lastLocation = self.center  //保存位置
    }
    
    @objc func detectPinch(_ sender: UIPinchGestureRecognizer)
    {
        let factor = sender.scale
        if factor > 1
        {
            //图片放大
            transform = CGAffineTransform(scaleX: lastScaleFactor+factor-1, y: lastScaleFactor+factor-1)
        }
        else
        {
            //缩小
            transform = CGAffineTransform(scaleX: lastScaleFactor*factor, y: lastScaleFactor*factor)
        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.ended
        {
            if factor > 1
            {
                lastScaleFactor = lastScaleFactor + factor - 1
            }
            else{
                lastScaleFactor = lastScaleFactor * factor
            }
        }
    }

}
