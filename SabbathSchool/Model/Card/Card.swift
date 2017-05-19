//
//  Card.swift
//  SabbathSchool
//
//  Created by André Pimentel on 04/04/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class superCard: Mappable {
    var collection: [cCard]?
    var enrolled: Int?
    var form: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        collection <- map["questoes"]
        enrolled <- map["matriculados"]
        form <- map["formularioId"]
    }
}

class cCard:Mappable {
    var questionId: Int?
    var title: String?
    var description: String?
    var value: String?
    var answerId: Int?
    var targetPercentual: String?
    var defineNumberPresence: Int?
    
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        questionId <- map["QuestaoId"]
        title <- map["Titulo"]
        description <- map["Descricao"]
        value <- map["Valor"]
        answerId <- map["RespostaId"]
        targetPercentual <- map["AlvoPercentual"]
        defineNumberPresence <- map["DefineNumeroPresente"]
    }
}
