//
//  Third_OneMoreLevel_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Third_OneMoreLevel_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Third_OneMoreLevel_> {
        return NSFetchRequest<Third_OneMoreLevel_>(entityName: "Third_OneMoreLevel_")
    }

    @NSManaged public var moreOneLevel_: Bool

}
