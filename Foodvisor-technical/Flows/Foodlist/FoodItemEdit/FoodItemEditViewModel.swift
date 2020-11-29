//
//  FoodItemEditViewModel.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 28/11/2020.
//

import Foundation

protocol FoodItemEditViewModelType {
    var name: String { get }
    
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
}
