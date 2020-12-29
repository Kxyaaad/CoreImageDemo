//
//  UIExtension.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/23.
//

import Foundation
import UIKit

extension UIImage {
    func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(reSize)
        UIGraphicsBeginImageContextWithOptions(reSize, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height:reSize.height))
        let  reSizeImage: UIImage  =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext ();
        return  reSizeImage;
    }
    
    func addFilter(filterKey:String? ) -> UIImage {
        let originalCIImage = CIImage(image: self)
        guard let filter = CIFilter(name: filterKey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        //判断是否具有某些可调整的参数
        if (filter.inputKeys.contains("inputIntensity")) {
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
        }
        
        let context = CIContext()
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
        
    }
    
    func addFilter(filterKrey:String?, toScale scale:CGFloat ) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let originalImage = reSizeImage(reSize: size)
        let originalCIImage = CIImage(image: originalImage)
        guard let filter = CIFilter(name: filterKrey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        let context = CIContext()
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
    }
}
