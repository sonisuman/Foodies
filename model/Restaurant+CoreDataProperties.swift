//
//  Restaurant+CoreDataProperties.swift
//  foodie
//
//  Created by Andi Setiyadi on 6/11/18.
//  Copyright © 2018 devhubs. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var address: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var website: String?
    @NSManaged public var storedLocation: StoredLocation?

}
