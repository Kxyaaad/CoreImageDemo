//
//  ThumbnailCell.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ThumbnilCell: UITableViewCell {
    
    var load = false
    
    var filterKeyString : String? {
        didSet {
            if self.load == false {
                self.addFilter()
                self.load = true
            }
        }
    }
    var imageName = "1"
    var fileExtension = ""
    var ImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.layer.shouldRasterize = true // 图片栅格化
        self.layer.drawsAsynchronously = true //异步绘制
        CreateUI()
    }
    
    func CreateUI() {
        self.ImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        
        //        self.addFilter()
        self.imageView?.image = nil
        self.ImageView.center = self.center
        self.ImageView.contentMode = .scaleAspectFill
        self.ImageView.backgroundColor = .systemGray
        self.ImageView.layer.cornerRadius = 8
        self.ImageView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.ImageView) //对于可编辑的CEll，必须添加到contentView
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func addFilter() {
        print("执行")
        let queue = DispatchQueue(label: self.filterKeyString ?? "test")
        guard let fileURL = Bundle.main.url(forResource: self.imageName, withExtension: self.fileExtension) else {print("未能查到文件路径", self.imageName); return }
        print("文件路径", fileURL)
        queue.async {
           
            let originalImage = CIImage(contentsOf: fileURL)
            guard let filter = CIFilter(name: self.filterKeyString ?? "" ) else {
                print("添加滤镜出错", self.filterKeyString)
                return
            }
            print("滤镜", self.filterKeyString)
            filter.setValue(originalImage, forKey: kCIInputImageKey)
            
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
