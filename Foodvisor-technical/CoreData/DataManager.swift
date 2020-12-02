//
//  DataManager.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func getFoodlist(completion: @escaping (Error?) -> Void)
    func saveModifications()
    func removeFoods()
    func removeAt(_ index: Int)
    func createFood() -> Food?
    func insertFood(_ food: Food)
    
    var foods: [Food]? { get }
}

class DataManager: DataManagerProtocol {
    var foodManager: FoodDataManager
    private var container: NSPersistentContainer
    
    private var api = FoodvisorApiImp()
    
    init(container: NSPersistentContainer) {
        
        // Core Data initialisation
        self.container = container

        foodManager = FoodDataManager(container: container)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("unresolved error while loading container\(error)")
            } else {
                self.foodManager.fetchFood()
            }
        }
    }
    
    // MARK - CoreData methods
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    // MARK - public methods and properties
    
    // fetch 2 series of Foods in order to display a full page
    func getFoodlist(completion: @escaping (Error?) -> Void) {
        api.getFoodList { (items, error) in
            if let items = items {
                do {
                    _ = try self.foodManager.createMany(items)
                    completion(nil)
                } catch {
                    print("An error occurred while creating foods: \(error)")
                    completion(error)
                }
            } else {
                completion(error)
            }
        }
    }
    
    // remove every foods in Coredata storage
    func removeFoods() {
        try? self.foodManager.drop()
    }
    
    func removeAt(_ index: Int) {
        if let item = foodManager.foods?[index] {
            self.container.viewContext.delete(item)
            self.foodManager.foods?.remove(at: index)
            saveModifications()
        }
    }
    
    var foods: [Food]? {
        return foodManager.foods
    }
    
    func saveModifications() {
        self.saveContext()
    }
    
    func createFood() -> Food? {
        return foodManager.createFood()
    }
    
    func insertFood(_ food: Food) {
        try? self.foodManager.insert(food)
    }
}
