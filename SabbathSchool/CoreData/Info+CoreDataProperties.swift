//
//  Info+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 25/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension Info {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Info> {
        return NSFetchRequest<Info>(entityName: "Info")
    }

    @NSManaged public var description_: String?
    @NSManaged public var descriptionValue_: String?
    @NSManaged public var image_: String?
    @NSManaged public var percentual_: Int16
    @NSManaged public var reportPercentual_: Int16
    @NSManaged public var smile_: String?
    @NSManaged public var title_: String?
    @NSManaged public var value_: Double
    @NSManaged public var questionId_: Int16

}
