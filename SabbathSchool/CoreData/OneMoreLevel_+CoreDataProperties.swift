//
//  OneMoreLevel_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 01/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension OneMoreLevel_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OneMoreLevel_> {
        return NSFetchRequest<OneMoreLevel_>(entityName: "OneMoreLevel_")
    }

    @NSManaged public var moreOneLevel_: Bool

}
