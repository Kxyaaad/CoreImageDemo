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
        self.ThumbnilTable = UITableView(frame: CGRect(x: 30, y: self.ImageView.frame.maxY + 30, width: self.view.frame.width - 60 , height: 100))
        self.ThumbnilTable.backgroundColor = .red
        self.view.addSubview(self.ThumbnilTable)
    }

    func addFilter(imageName: String) -> UIImage {
        
        guard let fileURL = Bundle.main.url(forResource: "1", withExtension: "jpg") else {return UIImage()}
        
        let originalImage = CIImage(contentsOf: fileURL)
        
        let filter = CIFilter(name: "CIDiscBlur")!
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

