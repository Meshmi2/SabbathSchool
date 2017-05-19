//
//  Class_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Class_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Class_> {
        return NSFetchRequest<Class_>(entityName: "Class_")
    }

    @NSManaged public var id_: Int16
    @NSManaged public var name_: String?

}
