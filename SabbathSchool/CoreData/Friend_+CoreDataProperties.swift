//
//  Friend_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Friend_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend_> {
        return NSFetchRequest<Friend_>(entityName: "Friend_")
    }

    @NSManaged public var instructor_: Bool
    @NSManaged public var name_: String?
    @NSManaged public var nameInstructor_: String?
    @NSManaged public var statusId_: String?
    @NSManaged public var id_: Int16

}
