//
//  ParkingRecordCell.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit

class ParkingRecordCell: BaseCell {
    
    var record: Record? {
        didSet {
            guard let record = record else {
                return
            }
            areaLabel.text = record.area
            serviceTimeLabel.text = record.serviceTime
            addressLabel.text = record.address
            nameLabel.text = record.name
        }
    }
    
    let areaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let serviceTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews() {
        let stackView = setupStackView()
        addSubview(stackView)
        stackView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 12, rightConstant: 0, widthConstant: 360, heightConstant: 0)
        addSubview(nameLabel)
        nameLabel.anchor(stackView.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 12, widthConstant: 200, heightConstant: 0)
    }
    
    func setupStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [areaLabel, serviceTimeLabel, addressLabel])
        stackView.backgroundColor = .red
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }
}

