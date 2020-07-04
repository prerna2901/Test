//
//  APIServiceCall.swift
//  AssigmentApp
//
//  Created by Prerna Chauhan on 02/07/20.
//  Copyright © 2020 Prerna Chauhan. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    lazy var endPoint: String = {
        return "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10"
    }()

    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
         guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
}
            do {
                let jsonArray: [[String: AnyObject]] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String: AnyObject]]
                print("json: \(jsonArray)")
                
                completion(.Success(jsonArray))
                    
                
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
}

enum Result<T> {
    case Success(T)
    case Error(String)
}





