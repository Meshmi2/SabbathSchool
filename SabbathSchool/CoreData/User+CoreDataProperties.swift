//
//  User+CoreDataProperties.swift
//  SabbathSchool
//
//  Created by André Pimentel on 23/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var ageGroupId_: Int32
    @NSManaged public var ageGroupName_: String?
    @NSManaged public var classId_: Int32
    @NSManaged public var className_: String?
    @NSManaged public var entity_: Int32
    @NSManaged public var entityLevel_: Int32
    @NSManaged public var entityName_: String?
    @NSManaged public var entityTypeName_: String?
    @NSManaged public var functionId_: Int32
    @NSManaged public var functionName_: String?
    @NSManaged public var name_: String?
    @NSManaged public var peopleId_: Int32
    @NSManaged public var periodId_: Int32
    @NSManaged public var periodName_: String?

}
