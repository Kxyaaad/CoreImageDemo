//
//  ThumbnailImage.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/28.
//

import UIKit

class ThumbnailImage: UIImage {
    var image:UIImage?
    init(image: UIImage) {
        self.image = image
    }
    
    func Filter() {
        let queue = DispatchQueue(label: "test")
        guard self.thumbImage != nil else { return }
        let originalImage = self.compressIMG(image: self.thumbImage!)
        let originalCIImage = CIImage(image: originalImage)
        queue.sync {
            guard let filter = CIFilter(name: self.filterKeyString ?? "" ) else {return }
            filter.setValue(originalCIImage, forKey: kCIInputImageKey)
            
            //判断是否具有某些可调整的参数
            if (filter.inputKeys.contains("inputIntensity")) {
                filter.setValue(0.5, forKey: kCIInputIntensityKey)
            }
            
            let context = CIContext()
            guard let cgImg : CGImage = context.createCGImage(filter.outputImage ?? CIImage(), from: (filter.outputImage ?? CIImage()).extent) else { return }
            
            DispatchQueue.main.async {
                
                self.ImageView.image = UIImage(cgImage: cgImg)
                self.ImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2))
                
            }
            
        }
    }

}
