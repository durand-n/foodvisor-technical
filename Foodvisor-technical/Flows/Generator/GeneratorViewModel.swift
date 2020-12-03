//
//  GeneratorViewModel.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 02/12/2020.
//

import Foundation

protocol GeneratorViewModelType {
    func calculateBestMeal(calories: Int) -> (result: (starter: FoodDataRepresentable, dish: FoodDataRepresentable, dessert: FoodDataRepresentable, total: String, isAbove: Bool)?, error: String?)
}

class GeneratorViewModel: GeneratorViewModelType {

    // MARK: - Private properties
    private var dataManager: DataManagerProtocol

    // MARK: - initialization
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    // MARK: - Calculate best meal
    func calculateBestMeal(calories: Int) -> (result: (starter: FoodDataRepresentable, dish: FoodDataRepresentable, dessert: FoodDataRepresentable, total: String, isAbove: Bool)?, error: String?) {
        guard let desserts = dataManager.foods?.filter({ $0.type == FoodType.dessert.rawValue }),
        let dishes = dataManager.foods?.filter({ $0.type == FoodType.dish.rawValue }),
        let starters = dataManager.foods?.filter({ $0.type == FoodType.starter.rawValue }),
        !desserts.isEmpty, !dishes.isEmpty, !starters.isEmpty else { return (nil, "Il n'y a pas assez de plats") }
        
        // Generator will try to find food with Ratio of 15% of the total for starter, 40% and 45% of dish and dessert
        let caloriesAimForStarter = Int32((calories / 100) * 15)
        let caloriesAimForDish = Int32((calories / 100) * 40)
        let caloriesAimFordessert = Int32((calories / 100) * 45)
        
        // Searching the food with the closest calorie value for our aim defined above
        let closestStarter = starters.enumerated().min( by: { abs($0.element.calories - caloriesAimForStarter) < abs($1.element.calories - caloriesAimForStarter) } )?.element
        let closestDish = dishes.enumerated().min( by: { abs($0.element.calories - caloriesAimForDish) < abs($1.element.calories - caloriesAimForDish) } )?.element
        let closestDessert = desserts.enumerated().min( by: { abs($0.element.calories - caloriesAimFordessert) < abs($1.element.calories - caloriesAimFordessert) } )?.element
        
        guard let starter = closestStarter, let dish = closestDish, let dessert = closestDessert else { return (nil, "Erreur inconnue") }
        let total = starter.calories + dish.calories + dessert.calories
        return (result: (starter: FoodDataRepresentable(food: starter), dish: FoodDataRepresentable(food: dish), dessert: FoodDataRepresentable(food: dessert), String(total) + " kcal", total > calories), nil)
    }
}

