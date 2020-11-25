//
//  AppCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 23/11/2020.
//
//

import UIKit

public class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override public func start() {
       
    }

}
