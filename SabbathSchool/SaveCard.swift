//
//  SaveCard.swift
//  SabbathSchool
//
//  Created by André Pimentel on 05/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class cSaveQuestions:Mappable {
    var result: Bool?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result    <- map["resultado"]
    }
}
