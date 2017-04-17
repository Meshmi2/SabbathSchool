//
//  PeriodParemeters.swift
//  SabbathSchool
//
//  Created by André Pimentel on 29/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class periodMaster: Mappable {
    var period: [Period]?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        period <- map["Periodos"]
    }
}

class Period: Mappable {
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

