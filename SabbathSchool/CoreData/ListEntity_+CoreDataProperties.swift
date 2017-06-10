//
//  ListEntity_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 01/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension ListEntity_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity_> {
        return NSFetchRequest<ListEntity_>(entityName: "ListEntity_")
    }

    @NSManaged public var name_: String?
    @NSManaged public var numberOfClass: Int16
    @NSManaged public var quantityFilledOut_: Int16
    @NSManaged public var entityId_: Int16
    @NSManaged public var numberOfSaturday_: Int16

}
