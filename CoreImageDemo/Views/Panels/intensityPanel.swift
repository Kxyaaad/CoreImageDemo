//
//  intensityPanel.swift
//  CoreImageDemo
//
//  Created by Mac on 2021/1/12.
//

import UIKit

class UIIntensitySlider: UISlider {
    var delegate : intensitySliderDelegate!
    
    var miniValue: Float = 0.0
    var maxValue: Float = 0.0
    
    var inputKey:String = ""
    var defaultValue: Float = 0.0
    
    lazy var intValue = 0 /// 用于需要进行整数滑动的时候，优化性能，省电

    init(miniValue: Float, maxValue: Float, defaultValue: Float, inputKey: String, frame: CGRect) {
        super.init(frame: frame)
        self.miniValue = miniValue
        self.maxValue = maxValue
        self.defaultValue = defaultValue
        self.inputKey = inputKey
        
        self.minimumValue = miniValue
        self.maximumValue = maxValue
        self.setValue(defaultValue, animated: false)
        self.tintColor = .white
        self.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueChanged(sender: UISlider) {
        if self.inputKey == "inputLevels" {
            if Int(sender.value) != self.intValue { //如果整数值有变化才渲染
                self.intValue = Int(sender.value)
                self.delegate.intesitySliderValueDidChanges(value: CGFloat(self.intValue), inputKey: self.inputKey)
            }
        }else {
            self.delegate.intesitySliderValueDidChanges(value: CGFloat(sender.value), inputKey: self.inputKey)
        }
        
    }
}

protocol intensitySliderDelegate {
    func intesitySliderValueDidChanges(value:CGFloat, inputKey:String)
}


