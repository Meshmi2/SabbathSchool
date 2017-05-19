//
//  Status_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 03/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Status_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Status_> {
        return NSFetchRequest<Status_>(entityName: "Status_")
    }

    @NSManaged public var id_: Int16
    @NSManaged public var name_: String?

}
