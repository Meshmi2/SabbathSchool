//
//  ClassParameters.swift
//  SabbathSchool
//
//  Created by André Pimentel on 29/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper


class classMaster: Mappable {
    var classe: [cClass]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        classe <- map["Classes"]
    }
}

class cClass: Mappable {
    var id: Int?
    var name: String?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Nome"]
    }
}
