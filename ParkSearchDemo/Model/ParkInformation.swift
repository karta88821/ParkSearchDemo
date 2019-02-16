//
//  ParkInformation.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/16.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

struct ParkInfomation {
    let records: [[String: Any]]
    
    init?(json: [String: Any]) {
        guard let result = json["result"] as? [String: Any],
            let records = result["records"] as? [[String: Any]] else {
                return nil
        }
        self.records = records
    }
}
