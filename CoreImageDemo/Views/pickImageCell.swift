//
//  pickImageCell.swift
//  CoreImageDemo
//
//  Created by Kxy on 2020/12/26.
//

import UIKit

class pickImageCell: UIImageView {
    var filterKeyString : String?
    var thumbImage : UIImage? {
        willSet{
            if newValue != self.thumbImage {
                let que = DispatchQueue(label: "deal_filter")
                que.async {
                    self.addFilter()
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
    }
    
    func compressIMG(image : UIImage) -> UIImage{
        let scale = image.size.width / 200
        let size = CGSize(width: image.size.width / scale, height: image.size.height / scale)
        return image.reSizeImage(reSize: size, scale: 0)
    }
    
    func addFilter() {
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
                self.image = UIImage(cgImage: cgImg)
                self.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/2))
                
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
