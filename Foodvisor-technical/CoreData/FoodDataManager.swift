//
//  FoodDataManager.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import CoreData

class FoodDataManager {
    var foods: [Food]?
    var container: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func fetchFood() {
        foods = getFoods()
    }

    
    /// CREATE
    func insertOne(_ remoteFood: FoodvisorApiModel.Food) throws {
        let food = Food(context: self.context)
        
        food.calories = Int32(remoteFood.calories)
        food.carbs = remoteFood.carbs
        food.fat = remoteFood.fat
        food.fibers = remoteFood.fibers
        food.proteins = remoteFood.proteins
        food.thumbnail = remoteFood.thumbnail
        food.type = remoteFood.type
        food.displayName = remoteFood.displayName
        
        self.context.insert(food)
        self.foods?.append(food)
        try self.context.save()
    }
    
    // CREATE BATCH
    func insertMany(_ remoteFoods: [FoodvisorApiModel.Food]) throws -> [Food]? {
        remoteFoods.forEach { remoteFood in
            let food = Food(context: self.context)

            food.calories = Int32(remoteFood.calories)
            food.carbs = remoteFood.carbs
            food.fat = remoteFood.fat
            food.fibers = remoteFood.fibers
            food.proteins = remoteFood.proteins
            food.thumbnail = remoteFood.thumbnail
            food.type = remoteFood.type
            food.displayName = remoteFood.displayName
            
            self.context.insert(food)
            self.foods?.append(food)
        }
        try self.context.save()

        return self.foods?.suffix(remoteFoods.count)
    }
    
    /// READ
    private func getFoods() -> [Food]? {
        let data = try? self.context.fetch(Food.createFetchRequest())
        if let foods = data {
            return foods
        } else {
            return nil
        }
    }
    
    /// DELETE
    
    public func drop() throws {
        try Food.deleteAll(context: self.context)
    }
}

