//
//  Card_+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Card_ {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card_> {
        return NSFetchRequest<Card_>(entityName: "Card_")
    }

    @NSManaged public var id_: Int32
    @NSManaged public var title_: String?
    @NSManaged public var description_: String?
    @NSManaged public var value_: String?
    @NSManaged public var answer_: Int32
    @NSManaged public var presence: Int32
    @NSManaged public var target_: String?

}
