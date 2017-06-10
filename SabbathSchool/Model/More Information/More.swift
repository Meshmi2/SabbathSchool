//
//  More.swift
//  SabbathSchool
//
//  Created by André Pimentel on 22/05/17.
//  Copyright © 2017 IASD. All rights reserved.
//


import ObjectMapper

class superMore: Mappable {
    var collectionEntity: [entityList]?
    var total: Double?
    var entityTypeName: String?
    var percentual: Double?
    var oneMore: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        collectionEntity <- map["listaEntidades"]
        total <- map["numeroTotal"]
        entityTypeName <- map["nomeTipoEntidade"]
        percentual <- map["percentual"]
        oneMore <- map["maisUmNivel"]
    }
}

class entityList:Mappable {
    var entityId: Int?
    var entityName: String?
    var parentId: Int?
    var className: Int?
    var classId: Int?
    var registred: Int?
    var present: Int?
    var QN2: Int?
    var QP2: Double?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    var qn = "QN\(questionIdForSegue)"
    var qp = "QP\(questionIdForSegue)"
    
    func mapping(map: Map) {
        entityId <- map["EntidadeId"]
        entityName <- map["EntidadeNome"]
        parentId <- map["ParenteId"]
        className <- map["ClasseNome"]
        classId <- map["ClasseId"]
        registred <- map["matriculado"]
        present <- map["presente"]
        QN2 <- map["\(qn)"]
        QP2 <- map["\(qp)"]
    }
}
