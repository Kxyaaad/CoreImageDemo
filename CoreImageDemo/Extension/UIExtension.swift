//
//  UIExtension.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/23.
//

import Foundation
import UIKit

extension UIImage {
    func reSizeImage(reSize: CGSize, scale:CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(reSize)
        UIGraphicsBeginImageContextWithOptions(reSize, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height:reSize.height))
        let  reSizeImage: UIImage  =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext ();
        return  reSizeImage;
    }
}
