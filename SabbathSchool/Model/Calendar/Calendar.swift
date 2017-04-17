//
//  Calendar.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class cCalendar:Mappable {
    var date = ""
    var released = false
    var saturday = ""
    var status = ""
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        date    <- map["data"]
        released <- map["liberado"]
        saturday <- map["sabado"]
        status <- map["status"]        
    }
}
