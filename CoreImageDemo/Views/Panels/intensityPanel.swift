//
//  intensityPanel.swift
//  CoreImageDemo
//
//  Created by Mac on 2021/1/12.
//

import UIKit

class UIIntensitySlider: UISlider {
    var delegate : intensitySliderDelegate!
    
    var miniValue: CGFloat = 0.0
    var maxValue: CGFloat = 0.0
    
    var inputKey:String = ""

    init(miniValue: CGFloat, maxValue: CGFloat, inputKey: String, frame: CGRect) {
        super.init(frame: frame)
        self.miniValue = miniValue
        self.maxValue = maxValue
        self.inputKey = inputKey
        
        self.minimumValue = 0.0
        self.maximumValue = 1.0
        self.setValue(1.0, animated: false)
        self.tintColor = .white
        self.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func valueChanged(sender: UISlider) {
        print("滑动值", sender.value)
        self.delegate.intesitySliderValueDidChanges(value: CGFloat(sender.value), inputKey: self.inputKey)
    }
}

protocol intensitySliderDelegate {
    func intesitySliderValueDidChanges(value:CGFloat, inputKey:String)
}


