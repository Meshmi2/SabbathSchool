//
//  Instructor_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Instructor_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instructor_> {
        return NSFetchRequest<Instructor_>(entityName: "Instructor_")
    }

    @NSManaged public var id_: Int16
    @NSManaged public var name_: String?

}
