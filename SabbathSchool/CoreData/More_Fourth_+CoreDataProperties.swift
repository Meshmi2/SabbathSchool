//
//  More_Fourth_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 31/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension More_Fourth_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<More_Fourth_> {
        return NSFetchRequest<More_Fourth_>(entityName: "More_Fourth_")
    }

    @NSManaged public var classId: Int16
    @NSManaged public var className_: Int16
    @NSManaged public var entityId_: Int16
    @NSManaged public var entityName_: String?
    @NSManaged public var parentId_: Int16
    @NSManaged public var present: Int16
    @NSManaged public var qn2_: Int16
    @NSManaged public var qp2_: Double
    @NSManaged public var registred_: Int16
    @NSManaged public var questionId_: Int16

}
