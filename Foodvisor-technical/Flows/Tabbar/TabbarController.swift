//
//  TabbarController.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 01/12/2020.
//

import UIKit

protocol TabbarView: BaseView {
    var onListClick: ((UINavigationController) -> Void)? { get set }
    var onGeneratorClick: ((UINavigationController) -> Void)? { get set }
    var selectedIndex: Int { get }
    
    // switch Tab bar to new index
    func setNewIndex(index: TabbarController.Index)
}

class TabbarController: UITabBarController, TabbarView {

    // MARK: protocol
    var onListClick: ((UINavigationController) -> Void)?
    var onGeneratorClick: ((UINavigationController) -> Void)?
    
    enum Index: Int {
        case list = 0
        case generator = 1
    }
    
    private var isFirstViewWillAppear = true

    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tabBar.accessibilityLabel = "tabBar"
        self.view.backgroundColor = .white
        let listNavigationController = BaseNavigationController()
        listNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        listNavigationController.tabBarItem = UITabBarItem(title: "Recettes", image: UIImage(systemName: "list.dash"), tag: Index.list.rawValue)
        
        let generatorNavigationController = BaseNavigationController()
        generatorNavigationController.interactivePopGestureRecognizer?.isEnabled = true
        generatorNavigationController.tabBarItem = UITabBarItem(title: "Generateur", image: UIImage(systemName: "face.smiling"), tag: Index.generator.rawValue)
        
        
        tabBar.tintColor = .secondary
        
        viewControllers = [listNavigationController, generatorNavigationController]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // start on the list flow
        if isFirstViewWillAppear {
            guard let navigationController = viewControllers?[Index.list.rawValue] as? UINavigationController else { return }
            selectedIndex = 0
            onListClick?(navigationController)
            isFirstViewWillAppear = false
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            guard let navigationController = viewControllers?[Index.list.rawValue] as? UINavigationController else { return }
            self.onListClick?(navigationController)
        case 1:
            guard let navigationController = viewControllers?[Index.generator.rawValue] as? UINavigationController else { return }
            self.onGeneratorClick?(navigationController)

        default:
            break
        }
    }
    
    // MARK: protocol compliance
    func triggerCleaning() {
        guard let navigationController = viewControllers?[Index.list.rawValue] as? UINavigationController else { return }
        selectedIndex = 0
        onListClick?(navigationController)
    }
    
    func setNewIndex(index: TabbarController.Index) {
        selectedIndex = index.rawValue
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController else { return }
        switch index {
        case .list:
            self.onListClick?(navigationController)
        case .generator:
            self.onGeneratorClick?(navigationController)
        }
    }
}
