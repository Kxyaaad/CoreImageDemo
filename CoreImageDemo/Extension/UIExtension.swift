//
//  UIExtension.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/23.
//

import Foundation
import UIKit

typealias filterInputKeys = Array<String>

extension UIImage {
    func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(reSize)
        UIGraphicsBeginImageContextWithOptions(reSize, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height:reSize.height))
        let  reSizeImage: UIImage  =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext ();
        return  reSizeImage;
    }
    
    func addFilter(filterKey:String?, callback: (_ intputKets:filterInputKeys)-> Void ) -> UIImage {
        let originalCIImage = CIImage(image: self)
        guard let filter = CIFilter(name: filterKey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        callback(filter.inputKeys) // 回调
        //判断是否具有某些可调整的参数
        if (filter.inputKeys.contains("inputIntensity")) {
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
        }
        
        if (filter.inputKeys.contains("inputColor")) {
            let cicolor = CIColor(red: 0, green: 0, blue: 1)
            filter.setValue(cicolor, forKey: kCIInputColorKey)
        }
        
        let context = CIContext.init(mtlDevice: MTLCreateSystemDefaultDevice()!)
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
        
    }
    
    func addFilter(filterKey:String?, withInputSetings InputValues:Dictionary<String, Any>, callback: (_ intputKets:filterInputKeys)-> Void ) -> UIImage {
        let originalCIImage = CIImage(image: self)
        guard let filter = CIFilter(name: filterKey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)

        callback(filter.inputKeys) // 回调

        
        for inputValue in InputValues {
            switch inputValue.key {
            case "inputColor":
                filter.setValue(inputValue.value, forKey: kCIInputColorKey)
            default:
                continue
            }
        }

        let context = CIContext.init(mtlDevice: MTLCreateSystemDefaultDevice()!)
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
//        return self

    }

    func addFilter(filterKrey:String?, toScale scale:CGFloat ) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let originalImage = reSizeImage(reSize: size)
        let originalCIImage = CIImage(image: originalImage)
        guard let filter = CIFilter(name: filterKrey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        let context = CIContext.init(mtlDevice: MTLCreateSystemDefaultDevice()!)
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
    }
}
