//
//  MyCollectionViewCell.swift
//  hangge_1602
//
//  Created by hangge on 2017/3/15.
//  Copyright © 2017年 hangge. All rights reserved.
//

import UIKit

//自定义的Collection View单元格
class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titlLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10 // 设置圆角大小
          contentView.layer.masksToBounds = true // 启用掩码
        contentView.clipsToBounds = true
        self.layer.cornerRadius = 10 // 设置圆角大小
        self.layer.masksToBounds = true // 启用掩码
    }

}
