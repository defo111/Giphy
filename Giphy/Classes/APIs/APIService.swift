//
//  APIService.swift
//  Giphy
//
//  Created by Admin on 9/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import Result
import Moya

enum APIService {
    
    case getGiphys(tag: String)
}

extension APIService: TargetType {
    var baseURL: URL { return URL(string: Configurations.General.ApiURL)! }
    
    var path: String {
        switch self {
        case .getGiphys(tag: _):
            return "/v1/gifs/search"
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        case .getGiphys(tag: let tag):
            
            let dict = [
                "q": tag,
                "api_key": Configurations.General.ApiKey,
                "lang" : "uk",
                "limit" : 30
                ] as [String : Any]
            
            return dict
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {

        default:
            return URLEncoding.default
        }
    }
        var sampleData: Data {
        return "No test data".utf8Encoded
    }
    
    var task: Task {
        return .request
    }
    
    static func APIProvider() -> MoyaProvider<APIService> {
        
        let endpointClosure = { (target: APIService) -> Endpoint<APIService> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            
            // Sign all non-authenticating requests
            switch target {
            default:
                return defaultEndpoint
            }
        }
        let provider = MoyaProvider<APIService>(endpointClosure: endpointClosure)
        return provider
    }
}

extension APIService {
    
    static func performRequest(request: APIService, completionHandler: @escaping Completion) {
        
        let provider = APIService.APIProvider()
        provider.request(request) { (result) in
            switch (result) {
            case .success(let response):
                
                guard response.statusCode != 403 else {
                    
                    print("FAIL REQUEST: \(request)")
                    
                    return
                }
                
                completionHandler(result)
                
                break
            default:
                completionHandler(result)
            }
        }
    }
}

// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }
    
    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

