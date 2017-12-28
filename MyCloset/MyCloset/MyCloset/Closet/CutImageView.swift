//
//  CutImageView.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/24.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class CutImageView: UIView
{
    private var ifCut = false   //是否已裁剪
    private var points: [CGPoint] = []
    private var image: UIImage? = nil
    private var cutImage: UIImage? = nil
    private var cutImage_Adapt: UIImage? = nil
    private var x :CGFloat = 0.0
    private var y :CGFloat = 0.0
    private var w :CGFloat = 0.0
    private var h :CGFloat = 0.0
    
    public func setImage(image: UIImage)
    {
        w = UIScreen.main.bounds.width//self.bounds.width
        h = w * image.size.height / image.size.width
        x = 0
        y = (self.bounds.height / 2.0) - (h / 2.0)
        if y < 0
        {
            y = 0
        }
        let rect = CGRect(x: x ,y: y, width: w,  height: h)
        self.image = image.reSizeImage(reSize:rect.size)
        self.cutImage = self.image
        self.cutImage_Adapt = self.image
    }
   
    public func getImage() -> UIImage
    {
            return self.cutImage_Adapt!
    }
    override func touchesBegan(_ touches: (Set<UITouch>!), with event: UIEvent!)
    {
        ifCut = false
        if let touch = touches.first    //进行类型转化
        {
            let point = touch.location(in:self)     //获取当前点击位置
            points = [point]
        }
        
    }
    override func touchesMoved(_ touches: (Set<UITouch>!), with event: UIEvent!)
    {
        if let touch = touches.first    //进行类型转化
        {
            let point = touch.location(in:self)     //获取当前点击位置
            points += [point]
            self.setNeedsDisplay()
        }
        
        
    }
    override func touchesEnded(_ touches: (Set<UITouch>!), with event: UIEvent!)
    {
        ifCut = true
        if let touch = touches.first    //进行类型转化
        {
            let point = touch.location(in:self)     //获取当前点击位置
            points += [point]
            if points.count < 3
            {
                ifCut = false
                points = []
            }
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
     
        let drawRect = CGRect(x: x ,y: y, width: w,  height: h)
        if let im = image
        {
            if ifCut == true
            {
                im.alpha(0.4).draw(in:drawRect)
                let newim = im.toBeCut(points, drawRect)
                newim.draw(in: drawRect)
                cutImage = newim
                cutImage_Adapt = newim.crop(points, drawRect)
            }
            else
            {
                im.draw(in: drawRect)
            }
            
        }
        else {return}
        
        let context = UIGraphicsGetCurrentContext()!
        if points.count < 1
        {return}
        context.setLineWidth(6.0)
        let lengths:[CGFloat] = [30, 20]
        context.setLineDash(phase: 0, lengths: lengths)
        context.setStrokeColor(UIColor.gray.cgColor)
        
        context.move(to: points[0])
        for i in 1 ..< points.count
        {
            context.addLine(to: points[i])
        }
        if ifCut == true
        {
            context.closePath()

        }
        context.strokePath()
    }
}

extension UIImage
{
   
    func toBeCut(_ oPoints: [CGPoint], _ rect: CGRect) -> UIImage  //抠图, 返回一张尺寸不变的图片，用于当前显示
    {
        //输出尺寸
        let outputRect = rect
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        let dy = rect.minY
        var points = [CGPoint](oPoints)
        for i in 0 ..< points.count
        {
            points[i].y -= dy
        }
        context.move(to: points[0])
        for i in 1 ..< points.count
        {
             context.addLine(to: points[i])
        }
        context.closePath()
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height:self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
    
    func crop(_ oPoints: [CGPoint], _ rect: CGRect) -> UIImage //将图片裁剪至合适尺寸的图片，用于保存
    {
        let dy = rect.minY
        var points = [CGPoint](oPoints)
        for i in 0 ..< points.count
        {
            points[i].y -= dy
        }
        
        var left = points[0].x
        var right = points[0].x
        var top = points[0].y
        var bottom = points[0].y
        
        for i in 1 ..< points.count
        {
            if points[i].x < left
            {
                left = points[i].x
            }
            else if points[i].x > right
            {
                right = points[i].x
            }
            if points[i].y < top
            {
                top = points[i].y
            }
            else if points[i].y > bottom
            {
                bottom = points[i].y
            }
        }
        if top < 0
        {
            top = 0
        }
        if bottom < 0
        {
            bottom = 0
        }
        if left < 0
        {
            left = 0
        }
        if right < 0
        {
            right = 0
        }
        var outputRect = CGRect(x: left, y: top, width: right - left ,height: bottom - top)
  
        outputRect.origin.x *= self.scale
        outputRect.origin.y *= self.scale
        outputRect.size.width *= self.scale
        outputRect.size.height*=self.scale
            
        if let imageRef = self.cgImage!.cropping(to: outputRect)
        {
            let image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            return image
        }
        return self
    }
    func reSizeImage(reSize:CGSize) -> UIImage    //改变图片大小
    {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func alpha(_ value:CGFloat) -> UIImage          //改变图片透明度
    {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
    }
  
}
