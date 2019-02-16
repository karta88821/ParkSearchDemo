//
//  Infomation.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

struct Infomation: Codable {
    let success: Bool
    let result: Result
    
    struct Result: Codable {
        let resource_id: String
        let limit: Int
        let records: [Record]
    }
}

