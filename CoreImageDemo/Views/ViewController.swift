//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ViewController: UIViewController {
    
    var ImageView : UIImageView!
    var ThumbnilTable: UITableView!
    let FilterKeys = [
        "CIColorCrossPolynomial",
        "CIColorCube",
        "CIColorCubeWithColorSpace",
        "CIColorInvert",
        "CIColorMap",
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIFalseColor",
        "CIMaskToAlpha",
        "CIMaximumComponent",
        "CIMinimumComponent",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIVignette",
        "CIVignetteEffect"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let img = self.addFilter(imageName: "2")
        self.ImageView = UIImageView(frame: CGRect(x: 50, y: (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height)!, width: self.view.frame.width - 100, height: (self.view.frame.width - 100) / 3 * 4 ))
        ImageView.image = img
        ImageView.contentMode = .scaleAspectFit
        view.addSubview(ImageView)
        self.addThumbnail()
        
    }
    
    func addThumbnail() {
        self.ThumbnilTable = UITableView()
        
        self.ThumbnilTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100 , height: self.view.frame.width - 60))
        self.ThumbnilTable.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 80)
        //为了实现横向滚动效果，旋转90度
        self.ThumbnilTable.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi/2))
        self.ThumbnilTable.showsVerticalScrollIndicator = false
        self.ThumbnilTable.delegate = self
        self.ThumbnilTable.dataSource = self
        self.ThumbnilTable.register(ThumbnilCell.self, forCellReuseIdentifier: "THUMBILCELL")
        self.ThumbnilTable.separatorStyle = .none
        self.view.addSubview(self.ThumbnilTable)
    }
    
    func addFilter(imageName: String) -> UIImage {
        
        guard let fileURL = Bundle.main.url(forResource: "1", withExtension: "jpg") else {return UIImage()}
        
        let originalImage = CIImage(contentsOf: fileURL)
        
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(originalImage, forKey: kCIInputImageKey)
        
        //判断是否具有某些可调整的参数
        if (filter.inputKeys.contains("inputIntensity")) {
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
        }
        
        let context = CIContext()
        let cgImg = context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        return UIImage(cgImage: cgImg!)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FilterKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "THUMBILCELL", for: indexPath) as! ThumbnilCell
        cell.imageName = "1"
        cell.fileExtension = "jpg"
        cell.filterKeyString = self.FilterKeys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

