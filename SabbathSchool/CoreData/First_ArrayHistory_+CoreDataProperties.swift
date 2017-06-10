//
//  First_ArrayHistory_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension First_ArrayHistory_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<First_ArrayHistory_> {
        return NSFetchRequest<First_ArrayHistory_>(entityName: "First_ArrayHistory_")
    }

    @NSManaged public var namePeriod_: String?
    @NSManaged public var numberOfClass_: Int16
    @NSManaged public var numberOfSaturaday_: Int16
    @NSManaged public var quantityFilledOut_: Int16

}
