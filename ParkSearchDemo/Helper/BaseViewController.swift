//
//  BaseViewController.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    let mediator: Mediator
    
    init(mediator: Mediator) {
        self.mediator = mediator
        super.init(style: .plain)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
