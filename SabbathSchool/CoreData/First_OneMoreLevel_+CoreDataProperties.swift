//
//  First_OneMoreLevel_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension First_OneMoreLevel_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<First_OneMoreLevel_> {
        return NSFetchRequest<First_OneMoreLevel_>(entityName: "First_OneMoreLevel_")
    }

    @NSManaged public var moreOneLevel_: Bool

}
