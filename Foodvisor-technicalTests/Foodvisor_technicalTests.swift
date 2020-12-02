//
//  Foodvisor_technicalTests.swift
//  Foodvisor-technicalTests
//
//  Created by Benoît Durand on 23/11/2020.
//

import XCTest
import CoreData
@testable import Foodvisor_technical


class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    var foodManager: FoodDataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager(container: mockPersistantContainer)
        foodManager = dataManager.foodManager
        insertMock()
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func testCreateFood() {
        foodManager.fetchFood()
        XCTAssertEqual(dataManager.foods?.count, 1)
        XCTAssertEqual(foodManager.foods?.count ?? 0, 1)
        _ = try? foodManager.createMany([])
        XCTAssertEqual(dataManager.foods?.count, 1)
        try? foodManager.createOne(FoodvisorApiModel.Food(fibers: 0.5, calories: 20, displayName: "pates au sucre", thumbnail: nil, carbs: 0.1, fat: 23.0, type: "dish", proteins: 200.0))
        XCTAssertEqual(foodManager.foods?.count, 2)
    }
    
    func testViewModel() {
        foodManager.fetchFood()
        let viewModel: FoodlistViewModelType = FoodlistViewModel(dataManager: dataManager)
        XCTAssertEqual(viewModel.foodCount, 1)
        XCTAssertEqual(viewModel.getFood(row: 0)?.displayName, "plat test")
        XCTAssertEqual(viewModel.getDatafor(row: 0)?.calories, "123 kcal")
    }
    
    func insertMock() {
        let food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: mockPersistantContainer.viewContext)
        food.setValue("plat test", forKey: "displayName")
        food.setValue(123, forKey: "calories")
        do {
             try mockPersistantContainer.viewContext.save()
         }  catch {
             print("error \(error)")
         }
    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Food")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        try! mockPersistantContainer.viewContext.save()
    }
    
    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "Foodvisor_technical", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false // Make it simpler in test env
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )

                // Check if creating container wrong
                if let error = error {
                    fatalError("Create an in-mem coordinator failed \(error)")
                }
            }
            return container
        }()
}


