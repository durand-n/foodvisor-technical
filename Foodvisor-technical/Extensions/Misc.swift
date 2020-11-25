//
//  Misc.swift
//  Foodvisor-technical
//
//  Created by Benoît Durand on 24/11/2020.
//

import Foundation
import CoreData

extension NSManagedObject {
    static func deleteAll(context: NSManagedObjectContext) throws {
        try context.execute(NSBatchDeleteRequest(fetchRequest: self.fetchRequest()))
        try context.save()
    }
}
