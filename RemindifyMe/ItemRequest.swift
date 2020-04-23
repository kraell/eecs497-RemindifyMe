//
//  ItemRequest.swift
//  RemindifyMe
//
//  Created by Mohamed Mohamed on 3/18/20.
//  Copyright © 2020 Toasted Peanuts. All rights reserved.
//

import Foundation

enum ItemError:Error {
    case noUPCFound
    case otherError
}

struct ItemRequest {
    let resourceURL:URL
    
    init(upc:String) {
        let resourceString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(upc)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func getItem (completion: @escaping(Result<ApiItem, ItemError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noUPCFound))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let upcResponse = try decoder.decode(UpcResponse.self, from: jsonData)
                let item = upcResponse.items
                if (item.count <= 0) {
                    completion(.failure(.noUPCFound))
                }
                else {
                    completion(.success(item[0]))
                }
            }catch {
                completion(.failure(.otherError))
            }
        }
        dataTask.resume()
    }
}

























