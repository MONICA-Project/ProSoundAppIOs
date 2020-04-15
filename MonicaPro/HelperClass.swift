//
//  HelperClass.swift
//  RheinMonica
//
//  Created by Daniel Eriksson on 2018-05-02.
//  Copyright © 2018 CNet. All rights reserved.
//
import UIKit

import Foundation



extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    @objc
    class func appPrimaryColor() -> UIColor {
        return UIColor.monicaBlue()
    }
    @objc
    class func appSecondaryColor() -> UIColor {
        return UIColor.appGreen()
    }
    
    class func rheinRed() -> UIColor {
        return UIColor(rgb: 0xe43010)
    }
    @objc
    class func monicaBlue() -> UIColor {
        return UIColor(rgb: 0x302782)
    }
    @objc
    class func monicaBlueLight() -> UIColor {
        return UIColor(rgb: 0x6bb3c7)
    }
    @objc
    class func monicaYellowLight() -> UIColor {
        return UIColor(rgb: 0xf2ba50)
    }
    class func starYellow() -> UIColor {
        return UIColor(rgb: 0xf7c042)
    }
    class func appGreen() -> UIColor {
        return UIColor(rgb: 0x2c962e)
    }
    
    class func kappaOrange() -> UIColor {
        return UIColor.rheinRed()
        //return UIColor(rgb: 0xe47148)
    }
    
    class func kappaGray() -> UIColor {
        return UIColor.starYellow()
        //return UIColor(rgb: 0x84817d)
    }
    
    class func kappaBlue() -> UIColor {
        return UIColor.monicaBlue()
        //return UIColor(rgb: 0x669bb6)
    }
    
    class func kappaPurple() -> UIColor {
        return UIColor.appGreen()
        //return UIColor(rgb: 0x945e88)
    }
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
}
extension UIFont {
    @objc
    class func appPrimaryFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size)//UIFont(name: "VAGRoundedStd-Light", size: size)!
    }
    class func appPrimaryLightFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)//UIFont(name: "VAGRoundedStd-Light", size: size)!
    }
    @objc
    class func appSecondaryFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.heavy)//UIFont(name: "VAGRoundedStd-Bold", size: size)!
    }
}
extension Optional {

    func dictString(unknown:String = "-") -> String {
        
        let parsed = self as? String ?? unknown
        if parsed == "" {
            return unknown
        }else{
            return parsed
        }
    }
    func jsonDatePhenomSpecSeconds(addSeconds: Int)->String
    {
        var dateStr = self as? String ?? ""
        dateStr = String(dateStr.split(separator: ".").first ?? "")
        dateStr += "+00:00"
        var date = dateStr.jsonToDate()
        date = Calendar.current.date(byAdding: .second, value: addSeconds, to: date)!
        let format = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    func dictDate() -> Date {
        
        return self.dictString().jsonToDate()
    }
    
    
}
extension Date {
    

    func stringWithFormat(format: String)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    
    
}
extension String {
    
    
    func jsonToDate()->Date
    {
        let format = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let format2 = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = format2
        
        return dateFormatter.date(from: self) ?? dateFormatter2.date(from: self) ?? Date()
    }
    func jsonToDictionary() -> [String: Any] {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
}

extension Double {
    
    func autoFormat(unit: String) -> String {
        var megaUnit = "M" + unit
        if unit == "g" {
            megaUnit = "ton"
        }
        if self < 1000 || unit=="kr" {
            return String(format: "%.0f", self) + " " + unit
        }else if self < 10000 {
            return String(format: "%.2f", self/1000) + " k" + unit
        }else if self < 100000 {
            return String(format: "%.1f", self/1000) + " k" + unit
        }else if self < 1000000 {
            return String(format: "%.0f", self/1000) + " k" + unit
        }else if unit=="m"  {
            return String(format: "%.0f", self/10000) + " mil"
        }else if self < 10000000 {
            return String(format: "%.2f", self/1000000) + " " + megaUnit
        }else if self < 100000000 {
            return String(format: "%.1f", self/1000000) + " " + megaUnit
        }else {
            return String(format: "%.0f", self/1000000) + " " + megaUnit
        }
    }
    
    func formatThreeSig() -> String {
        
        if self < 10  {
            return String(format: "%.2f", self)
        }else if self < 100 {
            return String(format: "%.1f", self)
        }else  {
            return String(format: "%.0f", self) 
        }
    }
}
class HelperClass: NSObject {
}
