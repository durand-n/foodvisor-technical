//
//  CoordinatorFactory.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit
import CoreData

protocol CoordinatorFactory {
    func makeTabBarCoordinator(coordinatorFactory: CoordinatorFactory, router: Router) -> BaseCoordinator & TabbarProtocol
    
    func makeFoodlistCoordinator(navigationController: UINavigationController, factory: FoodlistModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator
    
    func makeGeneratorCoordinator(navigationController: UINavigationController, factory: FoodGeneratorModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator
}
