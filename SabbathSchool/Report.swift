//
//  Report.swift
//  SabbathSchool
//
//  Created by André Pimentel on 01/06/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class superReport: Mappable {
    var list: [cEntityList]?
    var history: [cArrayHistory]?
    var moreOneLevel: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["listaEntidades"]
        history <- map["arrayHistorico"]
        moreOneLevel <- map["maisUmNivel"]
    }
}

class cEntityList:Mappable {
    var name: String?
    var entityId: Int?
    var quantityFilledOut: Int?
    var numberOfClass: Int?
    var numberOfSaturday: Int?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["Nome"]
        entityId <- map["EntidadeId"]
        quantityFilledOut <- map["QuantidadePreenchido"]
        numberOfClass <- map["QuantidadeClasse"]
        numberOfSaturday <- map["QuantidadeSabados"]
    }
}

class cArrayHistory:Mappable {
    var namePeriod: String?
    var quantityFilledOut: Int?
    var numberOfSaturday: Int?
    var numberOfClass: Int?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        namePeriod <- map["nomePeriodo"]
        quantityFilledOut <- map["quantidadePreenchido"]
        numberOfSaturday <- map["Numerosabados"]
        numberOfClass <- map["quantidadeClasse"]
    }
}
