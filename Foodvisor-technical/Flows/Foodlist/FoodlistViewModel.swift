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
    func getFood(row: Int) -> Food?
    func removeAt(row: Int)
    func saveEdit()
    func initFoodlist()
}

class FoodlistViewModel: FoodlistViewModelType {
    
    // MARK: - Protocol compliance
    var onShowError: ((String) -> Void)?
    var onShowData: (() -> Void)?
    
    // MARK: - Private properties
    private var dataManager: DataManagerProtocol
    
    // MARK: - initialization
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func initFoodlist() {
        if let foods = dataManager.foods, !foods.isEmpty {
            self.onShowData?()
        } else {
            dataManager.getFoodlist { (error) in
                if error != nil {
                    self.onShowData?()
                } else {
                    self.onShowError?(error?.localizedDescription ?? "une erreur est survenue")
                }
            }
        }
    }
    
    // MARK: - Controller related methods/properties
    var foodCount: Int {
        return dataManager.foods?.count ?? 0
    }
    
    func getDatafor(row: Int) -> FoodDataRepresentable? {
        guard row < foodCount, let food = dataManager.foods?[row] else { return nil }
        return FoodDataRepresentable(name: food.displayName, pictureUrl: URL(string: food.thumbnail))
    }
    
    func getFood(row: Int) -> Food? {
        guard row < foodCount, let food = dataManager.foods?[row] else { return nil }
        return food
    }
    
    func removeAt(row: Int) {
        guard row < foodCount else { return }
        
        print(dataManager.foods?.count)
        dataManager.removeAt(row)
        print(dataManager.foods?.count)
    }
    
    func saveEdit() {
        self.dataManager.saveModifications()
    }
}

struct FoodDataRepresentable {
    var name: String
    var pictureUrl: URL?
    
}
