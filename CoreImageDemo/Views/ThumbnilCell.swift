//
//  ThumbnailCell.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ThumbnilCell: UITableViewCell {
    
    var load = false
    
    var filterKeyString : String?
    var thumbImage : UIImage? {
        didSet {
            if self.load == false {
                let que = DispatchQueue(label: "re")
                que.async {
                    self.addFilter()
                }
                
                self.load = true
            }
        }
        willSet{
            if newValue != self.thumbImage {
                self.load = false
            }
        }
    }
    var fileExtension = ""
    var ImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        self.layer.shouldRasterize = true // 图片栅格化, 究极影响画质，如果不是点对点的话，就会直接马赛克
        self.layer.drawsAsynchronously = true //异步绘制
        CreateUI()
    }
    
    func CreateUI() {
        self.ImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        self.ImageView.center = self.center
        self.ImageView.contentMode = .scaleAspectFill
        self.ImageView.backgroundColor = .black
        self.ImageView.layer.cornerRadius = 8
        self.ImageView.backgroundColor = .systemGroupedBackground
        self.ImageView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.ImageView) //对于可编辑的CEll，必须添加到contentView
        
    }
    
    func compressIMG(image : UIImage) -> UIImage{
        let scale = image.size.width / 200
        let size = CGSize(width: image.size.width / scale, height: image.size.height / scale)
        return image.reSizeImage(reSize: size, scale: 0)
    }
    
    
    func addFilter() {
        print("测试")
        let queue = DispatchQueue(label: "test")
        guard self.thumbImage != nil else { return }
        print("测试2", self.thumbImage?.pngData())
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
