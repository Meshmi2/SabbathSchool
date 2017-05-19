//
//  Are.swift
//  SabbathSchool
//
//  Created by André Pimentel on 19/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class ageMaster: Mappable {
    var age: [Age]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        age <- map["FaixaEtaria"]
    }
}

class Age: Mappable {
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
