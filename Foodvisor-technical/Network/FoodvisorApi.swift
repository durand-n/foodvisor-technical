//
//  foodvisorApi.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation

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
    func getFoodList(completion: @escaping ([FoodvisorApiModel.Food]?, Error?) -> Void) {
        
        var semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://landing-sandbox.foodvisor.io/itw/food/list/?foo=bar")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer iwn-31@!3pf(w]pmarewj236^in", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

//        if let url = URL(string: "https://landing-sandbox.foodvisor.io/itw/food/list/?foo=bar") {
//
//            var request = URLRequest(url: url)
//            request.addValue("Bearer iwn-31@!3pf(w]pmarewj236^in", forHTTPHeaderField: "Authorization")
//            request.httpMethod = "GET"
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let data = data {
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                       print(jsonString)
//                    }
//                    do {
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .iso8601
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let items = try decoder.decode([FoodvisorApiModel.Food].self, from: data)
//                        print(items)
//                        completion(items, error)
//                    } catch let error {
//                        completion(nil, error)
//                    }
//                } else {
//                    completion(nil, error)
//                }
//           }.resume()
//        } else {
//            completion(nil, nil)
//        }
    }
}
