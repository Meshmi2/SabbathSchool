//
//  Period_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Period_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period_> {
        return NSFetchRequest<Period_>(entityName: "Period_")
    }

    @NSManaged public var id_: Int16
    @NSManaged public var name_: String?

}
