//
//  FoodlistCoordinator.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import UIKit

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
    
    func showImagePicker(on: BaseView,completion: @escaping (_ image: UIImage?) -> Void) {

    }
    
    func showFoodlist() {
        let module = factory.makeFoodlistController(viewModel: FoodlistViewModel(dataManager: dataManager))
        let picker = ImagePickerHandler(sourceType: .photoLibrary)
        
        module.onEdit = { [weak self] food, index, isCreate in
            let editVm = FoodItemEditViewModel(item: food)
            let edit: FoodItemEditView = FoodItemEditController(viewModel: editVm)
            
            edit.onSave = {
                if isCreate {
                    module.didCreate(food: food, at: index)
                } else {
                    module.didEdit(row: index)
                }

                self?.router.dismissModule()
            }
            
            edit.onPresentImagePicker = { completion in
                picker.didSelect = { image in
                    completion(image)
                    Constants.pickerController.dismiss(animated: true, completion: nil)
                }
                edit.toPresent()?.present(Constants.pickerController, animated: true, completion: nil)
            }
            self?.router.present(edit)
        }
        
        self.router.push(module)
    }
    
}
