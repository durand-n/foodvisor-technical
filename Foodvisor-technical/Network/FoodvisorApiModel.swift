//
//  FoodvisorApiImp.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation

class FoodvisorApiModel {
    struct Food: Codable {
        let fibers: Double
        let calories: Int
        let displayName: String
        let thumbnail: String
        let carbs: Double
        let fat: Double
        let type: String
        let proteins: Double
    }
}
