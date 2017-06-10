//
//  Seccound_ArrayHistory_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Seccound_ArrayHistory_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Seccound_ArrayHistory_> {
        return NSFetchRequest<Seccound_ArrayHistory_>(entityName: "Seccound_ArrayHistory_")
    }

    @NSManaged public var namePeriod_: String?
    @NSManaged public var numberOfClass_: Int16
    @NSManaged public var numberOfSaturaday_: Int16
    @NSManaged public var quantityFilledOut_: Int16

}
