//
//  Extention.swift
//  AssigmentApp
//
//  Created by Prerna Chauhan on 02/07/20.
//  Copyright © 2020 Prerna Chauhan. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
extension Int {
func shorted() -> String {
    if self >= 1000 && self < 10000 {
        return String(format: "%.1fK", Double(self/100)/10).replacingOccurrences(of: ".0", with: "")
    }

    if self >= 10000 && self < 1000000 {
        return "\(self/1000)k"
    }

    if self >= 1000000 && self < 10000000 {
        return String(format: "%.1fM", Double(self/100000)/10).replacingOccurrences(of: ".0", with: "")
    }

    if self >= 10000000 {
        return "\(self/1000000)M"
    }

    return String(self)
}
}
    
extension UIImageView {

   func setRounded() {
    let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
extension Int
{
    func toString() -> String
    {
        var myString = String(self)
        return myString
    }
}
