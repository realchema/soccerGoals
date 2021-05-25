//
//  FavsTeams+CoreDataProperties.swift
//  
//
//  Created by Jose M Arguinzzones on 2021-05-24.
//
//

import Foundation
import CoreData


extension FavsTeams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavsTeams> {
        return NSFetchRequest<FavsTeams>(entityName: "FavsTeams")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var image: Data?

}
