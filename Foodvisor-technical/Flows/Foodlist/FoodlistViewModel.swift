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
    func createFood() -> Food?
    func insertFood(food: Food)
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
                    self.onShowError?(error?.localizedDescription ?? "une erreur est survenue")
                } else {
                    self.onShowData?()
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
        return FoodDataRepresentable(food: food)
    }
    
    func getFood(row: Int) -> Food? {
        guard row < foodCount, let food = dataManager.foods?[row] else { return nil }
        return food
    }
    
    func createFood() -> Food? {
        return dataManager.createFood()
    }
    
    func insertFood(food: Food) {
        dataManager.insertFood(food)
    }
    
    func removeAt(row: Int) {
        guard row < foodCount else { return }
        
        dataManager.removeAt(row)
    }
    
    func saveEdit() {
        self.dataManager.saveModifications()
    }
}

struct FoodDataRepresentable {
    var name: String
    var pictureName: String?
    var pictureUrl: URL?
    var calories: String
    
    init(food: Food) {
        self.name = food.displayName
        self.pictureUrl = URL(string: food.thumbnail ?? "")
        self.pictureName = food.fileName
        self.calories = String(food.calories) + " kcal"
    }
}
