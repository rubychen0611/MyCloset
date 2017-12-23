//
//  CutImageViewController.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/23.
//  Copyright © 2017年 nju. All rights reserved.
//

import UIKit

class CutImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if let image = curSelectedPhoto
        {
            imageView.image = image
        }
        // Dispose of any resources that can be recreated.
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
