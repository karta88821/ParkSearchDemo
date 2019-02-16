//
//  APIService.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func fetchData(completion: @escaping ((Data?, Error?) -> Void))
}

typealias APIResult = ((Data?, Error?) -> Void)

class APIService: APIServiceProtocol {
    
    private let baseUrlString =
    "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000225-002"
    
    let network: NetworkProtocol
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func fetchData(completion: @escaping APIResult) {
        network.request(baseUrlString, method: .get) { (data, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else {
                return completion(nil, APIError.requestFailed)
            }
            do {
                let recordsData = try self.transformToRecordsData(with: data)
                completion(recordsData, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    private func transformToRecordsData(with originalData: Data) throws -> Data {
        let json = try self.transformToDictionary(with: originalData)
        let recordDictionaries = try self.transformToRecordDictionaries(with: json)
        let recordsData = try self.transformToData(with: recordDictionaries)
        
        return recordsData
    }
    
    private func transformToDictionary(with data: Data) throws -> [String: Any] {
        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            throw APIError.parseJSONFailed
        }
        return json
    }
    
    private func transformToRecordDictionaries(with json: [String: Any]) throws -> [[String: Any]] {
        guard let recordDictionaries = ParkInfomation(json: json)?.records else {
            throw APIError.convertToRecordDictionariesFailed
        }
        return recordDictionaries
    }
    
    private func transformToData(with dictionaries: [[String: Any]]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: dictionaries, options: .prettyPrinted)
    }
    

}


