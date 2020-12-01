//
//  Food+CoreDataProperties.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var fibers: Double
    @NSManaged public var calories: Int32
    @NSManaged public var displayName: String
    @NSManaged public var thumbnail: String?
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var type: String
    @NSManaged public var proteins: Double
    @NSManaged public var fileName: String?

}
