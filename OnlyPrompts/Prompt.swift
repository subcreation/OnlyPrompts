//
//  Prompt.swift
//  OnlyPrompts
//
//  Created by Nathanael Roberton on 12/26/22.
//

import Foundation
import CloudKit
import SwiftUI

class CDArtPrompts: ObservableObject {
    @Published var lists: [ArtPrompt] = []
}

struct ArtPrompt: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var imageURL: URL?
    var credit: String = ""
}

//public typealias FetchCompletionHandler = (_ records: [CKRecord]?, _ cursor: CKQueryOperation.Cursor?) -> (Void)

class CKPrompt {
    static let database = CKContainer.default().publicCloudDatabase
    
    class func fetchArt(completion: @escaping(Result<[ArtPrompt], Error>) -> ()) {
        print("+++ fetch")
        let predicate = NSPredicate(value: true)
        let order = NSSortDescriptor(key: "order", ascending: true)
        let query = CKQuery(recordType: "CD_ImagePrompt", predicate: predicate)
        query.sortDescriptors = [order]
        
        var operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["image", "credit"]
        operation.resultsLimit = 20
        operation.qualityOfService = .userInteractive
        
        var newPrompts = [ArtPrompt]()
        
        operation.recordMatchedBlock = { (recordID, recordResult) in
            print("+++ recordFetchedBlock")
            switch recordResult {
            case .failure(let error):
                print("+++ recordFetchedBlock failed: \(error)")
            case .success(let record):
                var artPrompt = ArtPrompt()
                
                let imageAsset = record["image"] as? CKAsset
                let imageURL = imageAsset?.fileURL
                
                artPrompt.recordID = recordID
                artPrompt.imageURL = imageURL
                artPrompt.credit = record["credit"] as! String
                
                newPrompts.append(artPrompt)
            }
        }
        
        operation.queryResultBlock = { recordResult in
            print("+++ queryCompletionBlock")
            switch recordResult {
            case .failure(let error):
                print("*** failure: \(error)")
                completion(.failure(error))
            case .success(let cursor):
                if cursor != nil {
                    let nextOperation = CKQueryOperation(cursor: cursor!)
                    nextOperation.recordMatchedBlock = { (recordID, recordResult) in
                        switch recordResult {
                        case .failure(let error):
                            print("*** failure: \(error)")
                        case .success(let record):
                            var artPrompt = ArtPrompt()
                            
                            let imageAsset = record["image"] as? CKAsset
                            let imageURL = imageAsset?.fileURL
                            
                            artPrompt.recordID = recordID
                            artPrompt.imageURL = imageURL
                            artPrompt.credit = record["credit"] as! String
                            //                    print("+++ credit: \(artPrompt.credit)")
                            
                            newPrompts.append(artPrompt)
                        }
                    }
                    nextOperation.queryResultBlock = operation.queryResultBlock
                    nextOperation.resultsLimit = operation.resultsLimit
                    
                    operation = nextOperation
                    
                    database.add(operation)
                    print("+++ fetching next block \(String(describing: cursor))")
                } else {
                    completion(.success(newPrompts))
                }
            }
        }
        database.add(operation)
    }
}
