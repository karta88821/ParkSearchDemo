//
//  Errors.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/16.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case wrongURLString
    case requestFailded
}

enum APIError: Error {
    case requestFailed
    case parseJSONFailed
    case convertToRecordDictionariesFailed
}
