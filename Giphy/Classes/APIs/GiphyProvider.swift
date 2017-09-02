//
//  GiphyProvider.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Moya

class GiphyProvider: NSObject {

    // MARK: - Types
    
    typealias GiphysCompletion = (Result<[Giphy]>) -> Void

    // MARK: - Class methods

    class func getGiphys(tag: String, completion: @escaping GiphysCompletion) {
        
        APIService.performRequest(request: .getGiphys(tag: tag)) { (result) in
            
            switch result {
            case .success(let response):
                
                guard response.statusCode == 200 else {
                    completion(.failure(APIError(code: response.statusCode, message: nil)))
                    return
                }
                
                do {
                    
                    let dataJSON = try response.mapJSON()
                    
                    print(dataJSON)
                    
                    var giphys = [Giphy]()
                    
                    if let dataDict = dataJSON as? [String : Any] {
                                                
                        if let giphysArray = dataDict["data"] as? [[String: Any]] {
                            
                            for giphyDict in giphysArray {
                                                                
                                let giphy = Giphy(data: giphyDict)
                                giphys.append(giphy)
                            }
                        }
                    }
                    
                    completion(.success(giphys))
                }
                catch (let error) {
                    completion(.failure(APIError(error: error)))
                }
                break
            case .failure(let error):
                completion(.failure(APIError(error: error)))
                break
            }
        }
    }
    
}

