//
//  DataManager.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import CoreData

protocol DataManagerProtocol {
    func getFoodlist(completion: @escaping ([Food]?, Error?) -> Void)
    func saveModifications()
    func removeContacts()
    
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
    func getFoodlist(completion: @escaping ([Food]?, Error?) -> Void) {
        api.getFoodList { (items, error) in
            if let items = items {
                do {
                    let foods = try self.foodManager.insertMany(items)
                    completion(foods, nil)
                } catch {
                    print("An error occurred while creating foods: \(error)")
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    // remove every foods in Coredata storage
    func removeContacts() {
        try? self.foodManager.drop()
    }
    
    var foods: [Food]? {
        return foodManager.foods
    }
    
    func saveModifications() {
        self.saveContext()
    }
}
