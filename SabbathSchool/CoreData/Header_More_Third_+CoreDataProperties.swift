//
//  Header_More_Third_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 23/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Header_More_Third_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Header_More_Third_> {
        return NSFetchRequest<Header_More_Third_>(entityName: "Header_More_Third_")
    }

    @NSManaged public var nameEntityType_: String?
    @NSManaged public var oneMoreLevel_: Bool
    @NSManaged public var percentual: Double
    @NSManaged public var total_: Double

}
