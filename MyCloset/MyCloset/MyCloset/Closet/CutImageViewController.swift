//
//  CutImageViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/23.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class CutImageViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let image = curSelectedPhoto
        {
            imageView.image = image
        }
        // Do any additional setup after loading the view.

        
    let rightBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        rightBarBtn.image = #imageLiteral(resourceName: "save")
    self.navigationItem.rightBarButtonItem = rightBarBtn
    }

//返回按钮点击响应
@objc func backToPrevious()
{
   
    self.navigationController!.popViewController(animated: true)
    //dismiss(animated: true, completion: nil)
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
