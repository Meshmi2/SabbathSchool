//
//  Status.swift
//  SabbathSchool
//
//  Created by André Pimentel on 03/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class cStatus:Mappable {
    var id: Int?
    var name: String?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id    <- map["Id"]
        name <- map["Nome"]
    }
}
