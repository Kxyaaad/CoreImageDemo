//
//  ThumbnailCell.swift
//  CoreImageDemo
//
//  Created by Mac on 2020/12/18.
//

import UIKit

class ThumbnilCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        CreateUI()
    }
    
    func CreateUI() {
        let ImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        ImageView.center = self.center
        ImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi / 2))
        ImageView.backgroundColor = .blue
        self.addSubview(ImageView)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
