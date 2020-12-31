//
//  colorPanel.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/29.
//

import UIKit

class colorPanel: UIView {
    
    lazy var redSlider = UISlider()
    lazy var redValue = CGFloat(0)
    
    lazy var greenSlider = UISlider()
    lazy var greenValue = CGFloat(0)
    
    lazy var blueSlider = UISlider()
    lazy var blueValue = CGFloat(0)
    
    var setColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    weak var delegate : ColorPanelDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createUI()
    }
    
    func createUI() {
        self.redSlider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.width - 50, height: 20))
        self.redSlider.center = CGPoint(x:self.frame.width/2 , y:self.frame.height / 6)
        self.redSlider.minimumValue = 0.0
        self.redSlider.maximumValue = 1.0
        self.redSlider.thumbTintColor = .systemRed
        self.redSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        self.addSubview(self.redSlider)
        
        self.greenSlider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.width - 50, height: 20))
        self.greenSlider.center = CGPoint(x:self.frame.width/2 , y:self.frame.height / 2)
        self.greenSlider.minimumValue = 0.0
        self.greenSlider.maximumValue = 1.0
        self.greenSlider.thumbTintColor = .systemGreen
        self.greenSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        self.addSubview(self.greenSlider)
        
        self.blueSlider = UISlider(frame: CGRect(x: 0, y: 0, width: self.frame.width - 50, height: 20))
        self.blueSlider.center = CGPoint(x:self.frame.width/2 , y:self.frame.height / 6 * 5)
        self.blueSlider.minimumValue = 0.0
        self.blueSlider.maximumValue = 1.0
        self.blueSlider.thumbTintColor = .systemBlue
        self.blueSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        self.addSubview(self.blueSlider)
    }
    
    @objc func sliderValueChanged(_ sender:UISlider) {
        DispatchQueue.main.async { [self] in
            switch sender {
            case self.redSlider:
                self.redValue = CGFloat(sender.value)
                self.redSlider.tintColor = UIColor(red: self.redValue, green: 0, blue: 0, alpha: 1)
            case self.greenSlider:
                self.greenValue = CGFloat(sender.value)
                self.greenSlider.tintColor = UIColor(red: 0, green: self.greenValue, blue: 0, alpha: 1)
            case self.blueSlider:
                self.blueValue = CGFloat(sender.value)
                self.blueSlider.tintColor = UIColor(red: 0, green: 0, blue: self.blueValue, alpha: 1)
            default:
                return
            }
            self.setColor = UIColor(red: self.redValue, green: self.greenValue, blue: self.blueValue, alpha: 1)
            delegate?.didSetColorValue(colorValue: self.setColor)
        }
       
    }

}

@objc protocol ColorPanelDelegate {
    @objc func didSetColorValue(colorValue:UIColor)
}
