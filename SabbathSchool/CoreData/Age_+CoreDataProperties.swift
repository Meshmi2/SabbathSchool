//
//  Age_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 19/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Age_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Age_> {
        return NSFetchRequest<Age_>(entityName: "Age_")
    }

    @NSManaged public var id_: Int16
    @NSManaged public var name_: String?

}
