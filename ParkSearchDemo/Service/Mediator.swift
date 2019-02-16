//
//  Mediator.swift
//  ParkSearchDemo
//
//  Created by liao yuhao on 2019/2/16.
//  Copyright © 2019 liao yuhao. All rights reserved.
//

import Foundation

class Mediator {
    private let apiService: APIServiceProtocol
    private let persistency: Persistency
    
    init(apiService: APIServiceProtocol, persistency: Persistency) {
        self.apiService = apiService
        self.persistency = persistency
    }
    
    func fetchCorrespondingRecords(completion: @escaping ([Record]) -> Void) {
        print(doesnotExistAnyRecord())
        if doesnotExistAnyRecord() {
            fetchRecordsFromServer(completion: { (records) in
                DispatchQueue.main.async {
                    completion(records)
                }
            })
        } else {
            DispatchQueue.main.async {
                completion(self.fetchRecordsFromPersistency())
            }
        }
    }
    
    private func doesnotExistAnyRecord() -> Bool {
        return persistency.fetch(Record.self, perdicate: nil).isEmpty
    }
    
    private func fetchRecordsFromPersistency() -> [Record] {
        return persistency.fetch(Record.self, perdicate: nil)
    }
    
    private func fetchRecordsFromServer(completion: @escaping (([Record]) -> Void))  {
        apiService.fetchData { (data, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            
            DispatchQueue.global().async {
                do {
                    let records = try self.saveRecordsFromServer(data: data)
                    completion(records)
                } catch {
                    print(error)
                    completion([])
                }
            }
        }

    }
    
    private func saveRecordsFromServer(data: Data) throws -> [Record] {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
            fatalError("Failed to retrieve context")
        }
        
        let context = persistency.context
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = context
        
        let records = try decoder.decode([Record].self, from: data)
        persistency.save()
        
        return records
    }

}
