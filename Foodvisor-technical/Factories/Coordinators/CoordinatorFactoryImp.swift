//
//  CoordinatorFactoryImp.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit
import CoreData

class CoordinatorFactoryImp: CoordinatorFactory {
    func makeGeneratorCoordinator(navigationController: UINavigationController, factory: FoodGeneratorModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator {
        return GeneratorCoordinator(factory: factory, router: RouterImp(rootController: navigationController), dataManager: dataManager)
    }
    
    func makeTabBarCoordinator(coordinatorFactory: CoordinatorFactory, router: Router) -> BaseCoordinator & TabbarProtocol {
        return TabbarCoordinator(coordinatorFactory: coordinatorFactory, router: router)
    }
    
    func makeFoodlistCoordinator(navigationController: UINavigationController, factory: FoodlistModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator {
        return FoodlistCoordinator(factory: factory, router: RouterImp(rootController: navigationController), dataManager: dataManager)
    }
}
