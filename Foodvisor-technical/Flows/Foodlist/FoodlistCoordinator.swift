//
//  FoodlistCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation

class FoodlistCoordinator: BaseCoordinator {
    private let factory: FoodlistModuleFactory
    private let router: Router
    private let dataManager: DataManagerProtocol
    
    init(factory: FoodlistModuleFactory, router: Router, dataManager: DataManagerProtocol) {
        self.router = router
        self.factory = factory
        self.dataManager = dataManager
    }
    
    override func start() {
        showFoodlist()
    }
    
    func showFoodlist() {
        let module = factory.makeFoodlistController(viewModel: FoodlistViewModel(dataManager: dataManager))
        
        self.router.push(module)
    }
}
