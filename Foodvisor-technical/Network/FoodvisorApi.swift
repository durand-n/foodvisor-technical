//
//  foodvisorApi.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import Alamofire

enum FoodvisorApiRoutes {
    case FoodList
}

extension FoodvisorApiRoutes {
    var path: String {
        switch self {
        case .FoodList:
            return "\(Constants.SERVER_URL)/food/list"
        }
    }
}

protocol FoodvisorApi {
    func getFoodList(completion: @escaping ([FoodvisorApiModel.Food]?, Error?) -> Void)
}

class FoodvisorApiImp: FoodvisorApi {
    
    func sendHeaderInRedirection(_ session: URLSessionTask, _ request: URLRequest, _ response: HTTPURLResponse) -> URLRequest? {
        if request.url?.host == "landing-sandbox.foodvisor.io" {
            var newRequest = request
            newRequest.setValue(Constants.TOKEN, forHTTPHeaderField: "Authorization")
            return newRequest
        } else {
            return request
        }
    }
    
    func getFoodList(completion: @escaping ([FoodvisorApiModel.Food]?, Error?) -> Void) {
        let redirector = Redirector(behavior: Redirector.Behavior.modify(sendHeaderInRedirection(_:_:_:)))
        
        if let url = URL(string: FoodvisorApiRoutes.FoodList.path + "?foo=bar") {
            let headers: HTTPHeaders = ["Authorization": Constants.TOKEN]
            AF.request(url, method: .get, parameters: nil, headers: headers).redirect(using: redirector).responseString(encoding: String.Encoding.utf8) { response in
                switch response.result {
                case let .success(value):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let items = try decoder.decode([FoodvisorApiModel.Food].self, from: value.data(using: .utf8)!)
                        completion(items, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
    }
}
