//
//  RecordDetailCell.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit

class RecordDetailCell: BaseCell {
    
    var cellDisplayedItem: Item? {
        didSet {
            guard let cellDisplayedItem = cellDisplayedItem else { return }
            titleLabel.text = cellDisplayedItem.title
            contentLabel.text =  cellDisplayedItem.content
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(contentLabel)
        titleLabel.anchorCenterYToSuperview()
        titleLabel.anchor(nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 36)
        contentLabel.anchorCenterYToSuperview()
        contentLabel.anchor(nil, left: titleLabel.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 36)
    }
}

