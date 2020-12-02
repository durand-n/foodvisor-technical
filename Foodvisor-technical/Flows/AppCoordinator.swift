//
//  AppCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit
import CoreData

public class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()
    private var dataManager = DataManager(container: NSPersistentContainer(name: "Foodvisor_technical"))

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override public func start() {
        let tabBarCoordinator = coordinatorFactory.makeTabBarCoordinator(coordinatorFactory: coordinatorFactory, router: router)
        addChild(tabBarCoordinator)

        tabBarCoordinator.start()
    }

}
