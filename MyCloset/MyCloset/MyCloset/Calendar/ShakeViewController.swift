//
//  ShakeViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/28.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit
import AVFoundation

class ShakeViewController: UIViewController, AVAudioPlayerDelegate {

    //上图
    @IBOutlet weak var rockupImage: UIImageView!
    //下图
    @IBOutlet weak var rockdownImage: UIImageView!

    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //开启摇动感应
        UIApplication.shared.applicationSupportsShakeToEdit = true
        becomeFirstResponder()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
    {
        print("开始摇动")
        //开始动画
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
                
                self.rockupImage.frame.origin.y -= 80
                self.rockdownImage.frame.origin.y += 80
                }, completion: nil)
        // 设置音效
        let path1 = Bundle.main.path(forResource: "rock", ofType:"mp3")
        let data1 = NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1! as Data)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
            
            //结束动画
        UIView.animateKeyframes(withDuration: 0.5, delay: 1.0, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.rockupImage.frame.origin.y += 80
            self.rockdownImage.frame.origin.y -= 80
            }, completion: nil)
            }
        
        /**
         取消摇动
         */
        func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?)
        {
            print("取消摇动")
        }
        
        
        /**
         摇动结束
         */
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
    {
            print("摇动结束")
            ///此处设置摇一摇需要实现的功能
            
            /// 设置音效
        let path = Bundle.main.path(forResource: "rock_end", ofType:"mp3")
            let data = NSData(contentsOfFile: path!)
        self.player = try? AVAudioPlayer(data: data! as Data)
            self.player?.delegate = self
            self.player?.updateMeters()//更新数据
            self.player?.prepareToPlay()//准备数据
            self.player?.play()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}
