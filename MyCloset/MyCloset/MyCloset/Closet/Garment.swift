//
//  Garment.swift
//  MyCloset
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation
import UIKit
enum Season
{
    case any
    case springautumn
    case summer
    case winter
}

class Garment //单件衣服
{
    //MARK:Properties
    var photo : UIImage     //图片
    var largeclass: Int //所属大类
    var subclass: Int //所属小类
    var season: Season // 季节
    var brand: String //品牌
    var price: String //Int? //价格
    var boughtdate: Date? //买入日期
    var extrainfo: String //备注信息
    //MARK: Initialization
    
    init?(photo: UIImage, largeclass: Int, subclass: Int, season: Season, brand: String,price: String, boughtdate: Date?, extrainfo: String)
    {
        guard photo != #imageLiteral(resourceName: "defaultPhoto")
        else{
            return nil
        }
        self.photo = photo
        self.largeclass = largeclass
        self.subclass = subclass
        self.season = season
        self.brand = brand
        self.price = price
        self.boughtdate = boughtdate
        self.extrainfo = extrainfo
    }
}
