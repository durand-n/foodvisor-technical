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
    func makeFoodlistCoordinator(router: Router, factory: FoodlistModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator
}
