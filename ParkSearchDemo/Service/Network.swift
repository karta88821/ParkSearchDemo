//
//  Network.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/15.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

typealias NetworkResult = ((Data?, Error?) -> Void)

protocol NetworkProtocol {
    func request(_ urlString: String, method: HTTPMethod, completion: @escaping NetworkResult)
}

class Network: NetworkProtocol {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(_ urlString: String, method: HTTPMethod, completion: @escaping NetworkResult) {
        guard let url = URL(string: urlString) else {
            return completion(nil, NetworkError.wrongURLString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(nil, error)
            }
            guard let data = data else {
                return completion(nil, NetworkError.requestFailded)
            }
            
            return completion(data, nil)
        }.resume()
    }
}


