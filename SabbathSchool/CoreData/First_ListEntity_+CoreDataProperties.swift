//
//  First_ListEntity_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension First_ListEntity_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<First_ListEntity_> {
        return NSFetchRequest<First_ListEntity_>(entityName: "First_ListEntity_")
    }

    @NSManaged public var entityId_: Int16
    @NSManaged public var name_: String?
    @NSManaged public var numberOfClass: Int16
    @NSManaged public var numberOfSaturday_: Int16
    @NSManaged public var quantityFilledOut_: Int16

}