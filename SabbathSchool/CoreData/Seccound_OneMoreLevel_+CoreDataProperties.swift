//
//  Seccound_OneMoreLevel_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 02/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Seccound_OneMoreLevel_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Seccound_OneMoreLevel_> {
        return NSFetchRequest<Seccound_OneMoreLevel_>(entityName: "Seccound_OneMoreLevel_")
    }

    @NSManaged public var moreOneLevel_: Bool

}
