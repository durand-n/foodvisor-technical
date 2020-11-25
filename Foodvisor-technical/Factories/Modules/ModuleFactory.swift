//
//  ModuleFactory.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import Foundation

protocol FoodlistModuleFactory {
    func makeFoodlistController(viewModel: FoodlistViewModelType) -> FoodlistView
}
