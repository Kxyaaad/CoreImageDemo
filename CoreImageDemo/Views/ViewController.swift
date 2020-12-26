//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    var scrollView: UIScrollView!
    var ImageView : UIImageView!
    var ThumbnilTable: UITableView!
    var selectedFilter : String?
    var shareBtn : UIButton!
    var toakePhoto : UIButton!
    var image : UIImage? {
        didSet {
            self.addFilter()
//            self.ThumbnilTable.reloadData()
        }
    }
    
    var imageWithFilter: UIImage?
    
    let FilterKeys = [
        "CIColorCrossPolynomial",
        "CIColorCube",
        "CIColorCubeWithColorSpace",
        "CIColorInvert",
        "CIColorMonochrome",
        "CIColorPosterize",
        "CIFalseColor",
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
        self.creatUI()
        
    }
    
    func creatUI() {
        self.view.backgroundColor = .black
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height)!, width: self.view.frame.width, height: self.view.frame.height - (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height)!))
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        self.shareBtn = UIButton(frame: CGRect(x: self.view.frame.width - 70, y: 4, width: 30, height: 30))
        self.shareBtn.setBackgroundImage(UIImage.init(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white,renderingMode: .alwaysOriginal), for: [.normal])
        self.shareBtn.addTarget(self, action: #selector(self.saveToAlbum), for: .touchUpInside)
        self.scrollView.addSubview(self.shareBtn)
        
        self.toakePhoto = UIButton(frame: CGRect(x: 30, y: 0, width: 50, height: 50))
        self.toakePhoto.setImage(UIImage.init(systemName: "photo.fill.on.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white,renderingMode: .alwaysOriginal), for: [.normal])
        self.toakePhoto.addTarget(self, action: #selector(self.choseSourceTypr), for: .touchUpInside)
        self.scrollView.addSubview(self.toakePhoto)
        
        self.ImageView = UIImageView(frame: CGRect(x: 50, y: 50, width: self.view.frame.width - 100, height: (self.view.frame.width - 100) / 3 * 4 ))
        ImageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(ImageView)
        
//        self.addThumbnail()
        self.addThumbnailPicker()
        
    }
    
    
    /// 添加预览缩略图Table
    func addThumbnail() {
        self.ThumbnilTable = UITableView()
        self.ThumbnilTable.backgroundColor = .black
        self.ThumbnilTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100 , height: self.view.frame.width - 60))
        self.ThumbnilTable.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 80)
        //为了实现横向滚动效果，旋转90度
        self.ThumbnilTable.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi/2))
        self.ThumbnilTable.showsVerticalScrollIndicator = false
        self.ThumbnilTable.delegate = self
        self.ThumbnilTable.dataSource = self
        for id in self.FilterKeys {
            self.ThumbnilTable.register(ThumbnilCell.self, forCellReuseIdentifier: id)
        }
        self.ThumbnilTable.separatorStyle = .none
        self.scrollView.addSubview(self.ThumbnilTable)
    }
    
    func addThumbnailPicker() {
        let pickerView = ThumbnailPicker(frame: CGRect(x: 0, y: 0, width: 100 , height: self.view.frame.width))
        pickerView.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 80)
        pickerView.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi/2))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.scalesLargeContentImage = true
        self.scrollView.addSubview(pickerView)
    }
    
    /// 添加滤镜效果
    func addFilter() {
        guard self.image != nil else {return}
        if self.selectedFilter != nil {
            let originalImage = CIImage(image: self.image!)
            
            let filter = CIFilter(name: self.selectedFilter!)!
            filter.setValue(originalImage, forKey: kCIInputImageKey)
            
            //判断是否具有某些可调整的参数
            if (filter.inputKeys.contains("inputIntensity")) {
                filter.setValue(0.5, forKey: kCIInputIntensityKey)
            }
            
            let context = CIContext()
            let cgImg = context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
            let img = UIImage(cgImage: cgImg!)
            DispatchQueue.main.async {
                self.ImageView.image = img
                self.imageWithFilter = img
            }
        } else {
            self.ImageView.image = self.image
        }
        
        
        
    }
    
    /// 选择拍摄还是相册导入
    @objc func choseSourceTypr() {
        let alterController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let album = UIAlertAction(title: "相册", style: .default) { (_) in
            self.fromAlbum()
        }
        
        let camera = UIAlertAction(title: "拍摄", style: .default) { (_) in
            self.tokePhote()
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (_) in
            alterController.dismiss(animated: true) {
                
            }
        }
        alterController.addAction(album)
        alterController.addAction(camera)
        alterController.addAction(cancel)
        self.present(alterController, animated: true) {
            
        }
    }
    
    func tokePhote() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }else {
            print("当前设备不支持相机拍摄")
            return
        }
        
        self.present(imagePicker, animated: true) {
        }
        
        
    }
    
    func fromAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
        }else {
            print("无法打开相册")
            return
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func saveToAlbum() {
        if  self.imageWithFilter != nil {
            UIImageWriteToSavedPhotosAlbum(self.imageWithFilter!, self, #selector(self.imageSave(image:didFinishSavingWithError:contextInfo:)), nil)
        }else {
            let alterController = UIAlertController(title: nil, message: "选择图片为空", preferredStyle: .alert)
          
            let cancel = UIAlertAction(title: "确定", style: .cancel) { (_) in
                alterController.dismiss(animated: true) {
                    
                }
            }
            alterController.addAction(cancel)
            self.present(alterController, animated: true) {
                
            }
        }
        
    }
    
    
    @objc func imageSave(image:UIImage, didFinishSavingWithError error:NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let alterController = UIAlertController(title: "保存成功", message: "请到相册中查看", preferredStyle: .alert)
          
            let cancel = UIAlertAction(title: "确定", style: .cancel) { (_) in
                alterController.dismiss(animated: true) {
                    
                }
            }
            alterController.addAction(cancel)
            self.present(alterController, animated: true) {
                
            }
        }else{
            let alterController = UIAlertController(title: "保存错误", message: error!.description, preferredStyle: .alert)
          
            let cancel = UIAlertAction(title: "确定", style: .cancel) { (_) in
                alterController.dismiss(animated: true) {
                    
                }
            }
            alterController.addAction(cancel)
            self.present(alterController, animated: true) {
                
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FilterKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.FilterKeys[indexPath.row], for: indexPath) as! ThumbnilCell
        cell.thumbImage = self.image
        cell.filterKeyString = self.FilterKeys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFilter = self.FilterKeys[indexPath.row]
        self.addFilter()
    }
}

extension ViewController:UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.image = photo
            }else {
                print("未能获取")
            }
        }
    }
    
}

extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.FilterKeys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let imageView = pickImageCell(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.filterKeyString = self.FilterKeys[row]
        imageView.thumbImage = self.image
        return imageView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedFilter = self.FilterKeys[row]
        self.addFilter()
    }
    
}

