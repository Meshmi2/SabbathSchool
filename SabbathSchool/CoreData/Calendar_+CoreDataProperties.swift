//
//  Calendar_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Calendar_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calendar_> {
        return NSFetchRequest<Calendar_>(entityName: "Calendar_")
    }

    @NSManaged public var date_: String?
    @NSManaged public var released_: Bool
    @NSManaged public var saturday_: String?
    @NSManaged public var status_: String?
    @NSManaged public var function_: Int16

}
