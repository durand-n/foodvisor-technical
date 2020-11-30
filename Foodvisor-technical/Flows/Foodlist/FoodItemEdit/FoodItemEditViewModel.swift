//
//  FoodItemEditViewModel.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 28/11/2020.
//

import Foundation

enum FoodType: String, CaseIterable {
    case dish
    case starter
    case desert
    
}

protocol FoodItemEditViewModelType {
    var name: String { get }
    var calories: String { get }
    var fat: String { get }
    var carbs: String { get }
    var fibers: String { get }
    var proteins: String { get }
    var thumbnail: String { get }
    var typeIndex: Int { get }
    var typeList: [String] { get }

    func setData(name: String)
}

class FoodItemEditViewModel: FoodItemEditViewModelType {
    
    func setData(name: String) {
        food.displayName = name
    }
    
    private var food: Food
    
    init(item: Food) {
        self.food = item
    }
    
    var name: String {
        return food.displayName
    }
    
    var calories: String {
        return "\(food.calories)"
    }
    
    var fat: String {
        return "\(food.fat)"
    }
    
    var fibers: String {
        return "\(food.fibers)"
    }
    
    var proteins: String {
        return "\(food.proteins)"
    }
    
    var carbs: String {
        return "\(food.carbs)"
    }
    
    var thumbnail: String {
        return food.thumbnail
    }
    
    var typeIndex: Int {
        let types = typeList
        
        return types.firstIndex(of: food.type) ?? 0
    }
    
    var typeList: [String] {
        var foodTypes: [String] = []
        for item in FoodType.allCases {
            foodTypes.append(item.rawValue)
        }
        
        return foodTypes
    }
    
}
