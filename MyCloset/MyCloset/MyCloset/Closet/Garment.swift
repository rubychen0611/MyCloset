//
//  Garment.swift
//  MyCloset
//
//  Created by Apple on 2017/11/27.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation
import UIKit
import os.log

enum Season :String
{
    case any = "任意"
    case springautumn = "春秋"
    case summer = "夏"
    case winter = "冬"
}

class Garment :NSObject, NSCoding //单件衣服
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
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("clothes")

    //MARK: Types
    struct PropertyKey
    {
        static let photo = "photo"
        static let largeclass = "largeclass"
        static let subclass = "subclass"
        static let season = "season"
        static let brand = "brand"
        static let price = "price"
        static let boughtdate = "boughtdate"
        static let extrainfo = "extrainfo"
    }
    
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
    //MARK:NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(largeclass, forKey: PropertyKey.largeclass)
        aCoder.encode(subclass, forKey: PropertyKey.subclass)
        aCoder.encode(season.rawValue, forKey: PropertyKey.season)
        aCoder.encode(brand, forKey: PropertyKey.brand)
        aCoder.encode(price, forKey: PropertyKey.price)
        aCoder.encode(boughtdate, forKey: PropertyKey.boughtdate)
        aCoder.encode(extrainfo, forKey: PropertyKey.extrainfo)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        
        // Because photo is an optional property of Meal, just use conditional cast.
        guard let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage else {
            os_log("Unable to decode the photo for a Garment object.", log: OSLog.default, type: .debug)
            return nil
        }
        let largeclass = aDecoder.decodeInteger(forKey: PropertyKey.largeclass)
        let subclass = aDecoder.decodeInteger(forKey: PropertyKey.subclass)
        let season = Season(rawValue: (aDecoder.decodeObject(forKey:PropertyKey.season) as! String)) ?? .any //aDecoder.decodeObject(forKey:PropertyKey.season) as? Season
        let brand = aDecoder.decodeObject(forKey:PropertyKey.brand) as? String
        let price = aDecoder.decodeObject(forKey:PropertyKey.price) as? String
        let boughtdate = aDecoder.decodeObject(forKey:PropertyKey.boughtdate) as? Date
        let extrainfo = aDecoder.decodeObject(forKey:PropertyKey.extrainfo) as? String
        // Must call designated initializer.
        self.init(photo: photo, largeclass:largeclass, subclass:subclass, season:season, brand:brand!,price:price!, boughtdate:boughtdate,extrainfo:extrainfo!)
        
    }
    public static func loadClothes() -> [[[Garment]]]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Garment.ArchiveURL.path) as? [[[Garment]]]
    }
    public static func loadSampleGarments() {
        
        let photo1 = UIImage(named: "shortsleeves_1")
        let photo2 = UIImage(named: "shortsleeves_2")
        let photo3 = UIImage(named: "T-shirt_1")
        let photo4 = UIImage(named: "jeans_1")
        
        guard let shortsleeves_1 = Garment(photo: photo1!, largeclass: 0, subclass : 0, season: Season.summer, brand: "me&co", price: "129", boughtdate : nil, extrainfo : "") else {
            fatalError("Unable to instantiate shortsleeves1")
        }
        
        guard let shortsleeves_2 = Garment(photo: photo2!, largeclass: 0, subclass : 0, season: Season.summer, brand: "peacebird", price: "199", boughtdate : nil, extrainfo : "") else {
            fatalError("Unable to instantiate shortsleeves2")
        }
        guard let T_shirt_1 = Garment(photo: photo3!, largeclass: 0, subclass : 1, season: Season.springautumn, brand: "esprit", price: "250", boughtdate : nil, extrainfo : "") else {
            fatalError("Unable to instantiate tshirt1")
        }
        guard let jeans_1 = Garment(photo: photo4!, largeclass: 1, subclass : 0, season: Season.springautumn, brand: "esprit", price: "300", boughtdate : nil, extrainfo : "") else {
                fatalError("Unable to instantiate jeans1")
        }
        
        closet[0][0].append(shortsleeves_1)
        closet[0][0].append(shortsleeves_2)
        closet[0][1].append(T_shirt_1)
        closet[1][0].append(jeans_1)
    }
}
