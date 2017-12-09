//
//  Match.swift
//  MyCloset
//
//  Created by 陈紫琦 on 2017/12/8.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation
import UIKit
import os.log

class SingleGarment:NSObject, NSCoding
{
    var image : UIImage?
    var location: CGPoint?
    var scaleFactor: CGFloat?
    
    //MARK:Types
    struct PropertyKey
    {
        static let image = "image"
        static let location = "location"
        static let scaleFactor = "scaleFactor"
    }
    
    //MARK:initialization
    init(image: UIImage?, location: CGPoint?, scaleFactor: CGFloat?)
    {
        self.image = image
        self.location = location
        self.scaleFactor = scaleFactor
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(scaleFactor,  forKey:PropertyKey.scaleFactor)
       
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? CGPoint
        let scaleFactor = aDecoder.decodeObject(forKey: PropertyKey.scaleFactor) as? CGFloat
        self.init(image: image, location: location, scaleFactor: scaleFactor)
    }
}
class Match: NSObject, NSCoding
{
     //MARK:Properties
    var clothes : [SingleGarment]
    var screenShot: UIImage
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("DailyMatches")
    
    //MARK:Types
    struct PropertyKey
    {
        static let clothes = "clothes"
        static let screenShot = "screenShot"
    }
    
    //MARK: Initialization
    init(clothes: [SingleGarment], screenShot: UIImage)
    {
        self.clothes = clothes
        self.screenShot = screenShot
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(clothes, forKey: PropertyKey.clothes)
        aCoder.encode(screenShot, forKey: PropertyKey.screenShot)
        
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {   let clothes = aDecoder.decodeObject(forKey: PropertyKey.clothes) as? [SingleGarment]
        let screenShot = aDecoder.decodeObject(forKey: PropertyKey.screenShot) as? UIImage
        self.init(clothes: clothes!, screenShot: screenShot!)
    }
    
    public static func loadDailyMatches() -> [String: Match]?
    {
         return NSKeyedUnarchiver.unarchiveObject(withFile: Match.ArchiveURL.path) as? [String: Match]
    }
    
    //MARK: public methods
    public func getScreenShot() -> UIImage
    {
        return screenShot
    }
}
