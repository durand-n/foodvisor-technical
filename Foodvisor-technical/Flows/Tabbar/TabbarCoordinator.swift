//
//  TabbarCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 01/12/2020.
//

import UIKit
import CoreData

protocol TabbarProtocol {}

class TabbarCoordinator: BaseCoordinator, TabbarProtocol {
    // MARK: protocol compliance
    
    // MARK: attributes
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()
    private let tabbarModule: TabbarView = TabbarController()
    private var dataManager = DataManager(container: NSPersistentContainer(name: "Foodvisor_technical"))
    
    // MARK: start functions
    init(coordinatorFactory: CoordinatorFactory, router: Router) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    public override func start() {
        
        // OnNewsletter click is called when tabbar module appear
        tabbarModule.onListClick = { navigationController in
            if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                self.startListFlow(navigationController: nc)
            }
        }
        

        
        tabbarModule.onGeneratorClick = { navigationController in
            if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                    self.startGeneratorFlow(navigationController: nc)
                }
            }
        }

        router.setRootModule(tabbarModule)
    }

    
    
    // MARK: list flow
    private func startListFlow(navigationController: UINavigationController) {
        let listCoordinator = coordinatorFactory.makeFoodlistCoordinator(navigationController: navigationController, factory: moduleFactory, dataManager: dataManager)
        addChild(listCoordinator)
        
        listCoordinator.start()
    }
    
    // MARK: Generator flow
    private func startGeneratorFlow(navigationController: UINavigationController) {
        let generatorCoordinator = coordinatorFactory.makeGeneratorCoordinator(navigationController: navigationController, factory: moduleFactory, dataManager: dataManager)
        addChild(generatorCoordinator)

        generatorCoordinator.start()
    }
}

