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
        UIGraphicsEndImageContext();
        return  reSizeImage;
    }
    
    func addFilter(filterKey:String?, callback: (_ intputKets:filterInputKeys)-> Void ) -> UIImage {
        let originalCIImage = CIImage(image: self)
        guard let filter = CIFilter(name: filterKey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        callback(filter.inputKeys) // 回调
        
        let context = CIContext.init(mtlDevice: MTLCreateSystemDefaultDevice()!)
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
    }
    
    func addFilter(filterKey:String?, withInputSetings InputValues:Dictionary<String, Any>, callback: ((_ intputKets:filterInputKeys)-> Void)?)  -> UIImage {
        let originalCIImage = CIImage(image: self)
        guard let filter = CIFilter(name: filterKey ?? "" ) else {return self}
        filter.setValue(originalCIImage, forKey: kCIInputImageKey)
        
        callback?(filter.inputKeys) // 回调
        
        for inputValue in InputValues {
            filter.setValue(inputValue.value, forKey: inputValue.key)
        }
        let context = CIContext.init(mtlDevice: MTLCreateSystemDefaultDevice()!)
        guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return self}
        return UIImage(cgImage: cgImg)
        
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
        //        return UIImage(ciImage: filter.outputImage!)
    }
}
