//
//  GeneratorCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 02/12/2020.
//

import Foundation

class GeneratorCoordinator: BaseCoordinator {
    private let factory: FoodGeneratorModuleFactory
    private let router: Router
    private let dataManager: DataManagerProtocol
    
    init(factory: FoodGeneratorModuleFactory, router: Router, dataManager: DataManagerProtocol) {
        self.router = router
        self.factory = factory
        self.dataManager = dataManager
    }
    
    override func start() {
        showGenerator()
    }
    
    func showGenerator() {
        let module = factory.makeFoodGenerator(viewModel: GeneratorViewModel(dataManager: dataManager))
        router.push(module)
    }
}
