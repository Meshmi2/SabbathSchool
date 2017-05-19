//
//  Header_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 18/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Header_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Header_> {
        return NSFetchRequest<Header_>(entityName: "Header_")
    }

    @NSManaged public var registered_: Int16
    @NSManaged public var form_: Int16

}
