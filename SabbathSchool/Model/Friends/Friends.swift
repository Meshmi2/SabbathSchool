//
//  Friends.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper
import Foundation

class friendsMaster: Mappable {
    var allowsYouToChange: Bool?
    var friends: [cFriends]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        allowsYouToChange <- map["permiteAdicionarOuAlterar"]
        friends <- map["amigos"]
    }
    
}

class cFriends:Mappable {
    var name: String?
    var instructor: Bool?
    var nameInstructor: String?
    var statusStudyId: String?
    var id: Int?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["Nome"]
        instructor <- map["Instrutor"]
        nameInstructor <- map["NomeInstrutor"]
        statusStudyId <- map["StautsstudoId"]
        id <- map["id"]
    }
}

