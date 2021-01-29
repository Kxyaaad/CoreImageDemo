//
//  ViewController.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    var ImageView : UIImageView! //预览大图
    var imageReview: UIImage? { //原图出具
        didSet {
            self.addFilter()
        }
    }//预览效果图片
    var ThumbnilTable: UITableView! //预览小图TableView
    var ThumbnailPicker: UIPickerView! //预览小图PickerView
    var selectedFilter : String? { //被选中的滤镜
        willSet {
            self.filterTitle.text = newValue
        }
    }
    var filterTitle: UITextField! //选中滤镜标题
    var shareBtn : UIButton! //分享保存按钮
    var toakePhoto : UIButton! //选择照片按钮
    var image : UIImage?
    var imageWithFilter: UIImage? //添加滤镜后的原图
    
    var thumbnailImages:Array<UIImage?> = [] //缩略图数组
    
    lazy var panelView  = colorPanel() //调色板
    var intensitySlider : UIIntensitySlider?//强度调控
    
    lazy var touchX:CGFloat = 0.0
    lazy var touchY:CGFloat = 0.0
    
    var filterInputSetings : Dictionary<String, Any> = [:]//调节滤镜需要传入的参数
    
    let FilterKeys = [
        "CIColorCube",
        "CIColorInvert",
        "CIColorMonochrome",
        "CIColorPosterize",
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
        self.shareBtn = UIButton(frame: CGRect(x: self.view.frame.width - 70, y: UIApplication.shared.windows[0].windowScene!.statusBarManager!.statusBarFrame.height + 10, width: 30, height: 30))
        self.shareBtn.setBackgroundImage(UIImage.init(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white,renderingMode: .alwaysOriginal), for: [.normal])
        self.shareBtn.addTarget(self, action: #selector(self.saveToAlbum), for: .touchUpInside)
        self.view.addSubview(self.shareBtn)
        
        self.toakePhoto = UIButton(frame: CGRect(x: 30, y: UIApplication.shared.windows[0].windowScene!.statusBarManager!.statusBarFrame.height + 10, width: 50, height: 50))
        self.toakePhoto.setImage(UIImage.init(systemName: "photo.fill.on.rectangle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))?.withTintColor(.white,renderingMode: .alwaysOriginal), for: [.normal])
        self.toakePhoto.addTarget(self, action: #selector(self.choseSourceTypr), for: .touchUpInside)
        self.view.addSubview(self.toakePhoto)
        
        self.ImageView = UIImageView(frame: CGRect(x: 50, y: self.shareBtn.frame.maxY + 10 , width: self.view.frame.height / 3 / 4 * 3, height: self.view.frame.height / 3 ))
        self.ImageView.center = CGPoint(x: self.view.center.x, y: self.ImageView.center.y)
        ImageView.contentMode = .scaleAspectFit
        self.view.addSubview(ImageView)
        
        self.filterTitle = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        self.filterTitle.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 25)
        self.filterTitle.textAlignment = .center
        self.filterTitle.textColor = .white
        self.filterTitle.text = self.selectedFilter
        self.view.addSubview(self.filterTitle)
        
        self.addThumbnailPicker()
        
        
    }
    
    
    /// 添加预览缩略图Table
    func addThumbnail() {
        self.ThumbnilTable = UITableView()
        self.ThumbnilTable.backgroundColor = .black
        self.ThumbnilTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100 , height: self.view.frame.width - 60))
        self.ThumbnilTable.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 100)
        //为了实现横向滚动效果，旋转90度
        self.ThumbnilTable.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi/2))
        self.ThumbnilTable.showsVerticalScrollIndicator = false
        self.ThumbnilTable.delegate = self
        self.ThumbnilTable.dataSource = self
        for id in self.FilterKeys {
            self.ThumbnilTable.register(ThumbnilCell.self, forCellReuseIdentifier: id)
        }
        self.ThumbnilTable.separatorStyle = .none
        self.view.addSubview(self.ThumbnilTable)
    }
    
    func addThumbnailPicker() {
        self.ThumbnailPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 150 , height: self.view.frame.width))
        self.ThumbnailPicker.center = CGPoint(x: self.view.center.x, y: self.ImageView.frame.maxY + 100)
        self.ThumbnailPicker.transform = CGAffineTransform.init(rotationAngle: -CGFloat(Double.pi/2))
        self.ThumbnailPicker.delegate = self
        self.ThumbnailPicker.dataSource = self
        
        self.view.addSubview(self.ThumbnailPicker)
    }
    
    func addControlPanel() {
        panelView = colorPanel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: 150))
        panelView.center = CGPoint(x: self.view.center.x, y: self.ThumbnailPicker.frame.maxY + 90)
        panelView.backgroundColor = .black
        panelView.delegate = self
        self.view.addSubview(panelView)
    }
    
    func addIntensitySlider(miniValue: Float, maxValue: Float, defaultValue: Float, inputKey: String, frame:CGRect ) {
        let intensitySlider = UIIntensitySlider(miniValue: miniValue, maxValue: maxValue, defaultValue: defaultValue, inputKey: inputKey, frame: frame)
        intensitySlider.delegate = self
        self.view.addSubview(intensitySlider)
    }
    
    /// 添加滤镜效果
    func addFilter() {
        DispatchQueue.main.async {
            guard self.image != nil else {return}
            self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, callback: { (filterInputKeys) in
                print("可调参数", filterInputKeys)
            })
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
        if  self.image != nil {
            self.imageWithFilter = self.image!.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: nil)
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
        self.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = photo
            self.imageReview = photo.reSizeImage(reSize: CGSize(width: photo.size.width * (self.ImageView.frame.height / photo.size.height), height: self.ImageView.frame.height))
            self.thumbnailImages = []
            //渲染图片
            let que = DispatchQueue(label: "render_image")
            let group = DispatchGroup()
            let compressImage = self.image?.reSizeImage(reSize: CGSize(width: 200, height: photo.size.height * (200 / photo.size.width)))
            que.async {
                for filter in self.FilterKeys {
                    let image = compressImage!.addFilter(filterKey: filter) { (filterInputKeys) in
                    }
                    if self.thumbnailImages.count <= self.FilterKeys.firstIndex(of: filter)! {
                        self.thumbnailImages.append(image)
                    }else {
                        self.thumbnailImages[self.FilterKeys.firstIndex(of: filter)!] = image
                    }
                    
                }
            }
            group.notify(queue: que) {
                DispatchQueue.main.async {
                    self.ThumbnailPicker.reloadAllComponents()
                }
            }
            
        }else {
            print("未能获取")
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
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        if self.thumbnailImages.count >= row + 1 {
            imageview.image = self.thumbnailImages[row]
        }
        imageview.contentMode = .scaleAspectFit
        imageview.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        return imageview
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 90
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.filterInputSetings = [:] // 清空滤镜效果
        self.panelView.removeFromSuperview()
        for subView in self.view.subviews {
            if subView.isKind(of: UIIntensitySlider.self) {
                subView.removeFromSuperview()
            }
        }
        self.selectedFilter = self.FilterKeys[row]
        
        switch row {
        case 2:
            self.addControlPanel()
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputIntensity", frame: CGRect(x: 50, y: self.panelView.frame.maxY + 50, width: self.view.frame.width - 100, height: 50))
            break
        case 3:
            self.addIntensitySlider(miniValue: 0.0, maxValue: 20.0, defaultValue: 6.0, inputKey: "inputLevels", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 50, width: self.view.frame.width - 50, height: 50))
            break
        case 14:
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputIntensity", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 50, width: self.view.frame.width - 50, height: 50))
            break
        case 15:
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputRadius", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 100, width: self.view.frame.width - 50, height: 50))
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputIntensity", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 50, width: self.view.frame.width - 50, height: 50))
            break
        case 16:
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputRadius", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 100, width: self.view.frame.width - 50, height: 50))
            self.addIntensitySlider(miniValue: 0.0, maxValue: 1.0, defaultValue: 1.0, inputKey: "inputIntensity", frame: CGRect(x: 50, y: self.ThumbnailPicker.frame.maxY + 50, width: self.view.frame.width - 50, height: 50))
            break
        default:
            break
        }
        
        self.addFilter()
    }
    
}


extension ViewController: ColorPanelDelegate, intensitySliderDelegate {
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedFilter == "CIVignetteEffect" {
            self.touchX = event?.allTouches?.first?.location(in: self.ImageView).x ?? 0.0
            self.touchY = event?.allTouches?.first?.location(in: self.ImageView).y ?? 0.0
            self.filterInputSetings["inputCenter"] = CIVector(x: self.touchX / self.ImageView.frame.size.width * self.ImageView.image!.size.width, y: (self.ImageView.image!.size.height - self.touchY - self.ImageView.frame.height) / self.ImageView.frame.size.height * self.ImageView.image!.size.height )
            DispatchQueue.main.async {
                self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: { (_) in
                    
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedFilter == "CIVignetteEffect" {
            self.touchX = event?.allTouches?.first?.location(in: self.ImageView).x ?? 0.0
            self.touchY = event?.allTouches?.first?.location(in: self.ImageView).y ?? 0.0
            self.filterInputSetings["inputCenter"] = CIVector(x: self.touchX / self.ImageView.frame.size.width * self.ImageView.image!.size.width, y: (self.ImageView.image!.size.height - self.touchY - self.ImageView.frame.height) / self.ImageView.frame.size.height * self.ImageView.image!.size.height )
            DispatchQueue.main.async {
                self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: { (_) in
                    
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.selectedFilter == "CIVignetteEffect" {
            self.touchX = event?.allTouches?.first?.location(in: self.ImageView).x ?? 0.0
            self.touchY = event?.allTouches?.first?.location(in: self.ImageView).y ?? 0.0
            self.filterInputSetings["inputCenter"] = CIVector(x: self.touchX / self.ImageView.frame.size.width * self.ImageView.image!.size.width, y: (self.ImageView.image!.size.height - self.touchY - self.ImageView.frame.height) / self.ImageView.frame.size.height * self.ImageView.image!.size.height )
            DispatchQueue.main.async {
                self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: { (_) in
                    
                })
            }
        }
    }
    
    func intesitySliderValueDidChanges(value: CGFloat, inputKey: String) {
        if self.selectedFilter == "CIVignetteEffect" {
            self.filterInputSetings["inputCenter"] = CIVector(x: self.touchX / self.ImageView.frame.size.width * self.ImageView.image!.size.width, y: (self.ImageView.image!.size.height - self.touchY - self.ImageView.frame.height) / self.ImageView.frame.size.height * self.ImageView.image!.size.height )
        }
        if self.ImageView.image != nil {
            self.filterInputSetings[inputKey] = value
            DispatchQueue.main.async {
                self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: { (_) in
                    
                })
            }
        }
    }
    
    
    func didSetColorValue(colorValue: UIColor) {
        if self.ImageView.image != nil {
            let filterCiColor = CIColor(color: colorValue)
            self.filterInputSetings["inputColor"] = filterCiColor
            DispatchQueue.main.async {
                self.ImageView.image = self.imageReview?.addFilter(filterKey: self.selectedFilter, withInputSetings: self.filterInputSetings, callback: { (_) in
                    
                })
            }
        }
        
    }
}

extension UIImageView {
    
}
