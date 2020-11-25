//
//  ModuleFactoryImp.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import Foundation

final class ModuleFactoryImp {}

extension ModuleFactoryImp: FoodlistModuleFactory {
    func makeFoodlistController(viewModel: FoodlistViewModelType) -> FoodlistView {
        return FoodlistController(viewModel: viewModel)
    }
}
