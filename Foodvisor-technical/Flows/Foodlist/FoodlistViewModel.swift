//
//  FoodlistViewModel.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation

// MARK: - Protocol definition
protocol FoodlistViewModelType {
    var onShowError: ((String) -> Void)? { get set }
    var onShowData: (() -> Void)? { get set }
    var foodCount: Int { get }
    func getDatafor(row: Int) -> FoodDataRepresentable?
    func initFoodlist()
}

class FoodlistViewModel: FoodlistViewModelType {
    // MARK: - Protocol compliance
    var onShowError: ((String) -> Void)?
    var onShowData: (() -> Void)?
    
    // MARK: - Private properties
    private var foods: [Food]
    private var dataManager: DataManagerProtocol
    
    // MARK: - initialization
    init(dataManager: DataManagerProtocol) {
        self.foods = []
        self.dataManager = dataManager
    }
    
    func initFoodlist() {
        if let foods = dataManager.foods, !foods.isEmpty {
            self.foods = foods
            self.onShowData?()
        } else {
            dataManager.getFoodlist { (items, error) in
                if let items = items {
                    self.foods = items
                    self.onShowData?()
                } else {
                    self.onShowError?(error?.localizedDescription ?? "une erreur est survenue")
                }
            }
        }
    }
    
    // MARK: - Controller related methods/properties
    var foodCount: Int {
        return foods.count
    }
    
    func getDatafor(row: Int) -> FoodDataRepresentable? {
        return FoodDataRepresentable(name: "blaaaa", picture: "")
    }
}

struct FoodDataRepresentable {
    var name: String
    var picture: String
    
}
