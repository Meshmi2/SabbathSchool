//
//  Seccound_ListEntity_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Seccound_ListEntity_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Seccound_ListEntity_> {
        return NSFetchRequest<Seccound_ListEntity_>(entityName: "Seccound_ListEntity_")
    }

    @NSManaged public var entityId_: Int16
    @NSManaged public var name_: String?
    @NSManaged public var numberOfClass: Int16
    @NSManaged public var numberOfSaturday_: Int16
    @NSManaged public var quantityFilledOut_: Int16

}
