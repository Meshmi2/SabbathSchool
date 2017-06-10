//
//  InitialInformation.swift
//  SabbathSchool
//
//  Created by André Pimentel on 27/03/17.
//  Copyright © 2017 IASD. All rights reserved.
//

import ObjectMapper

class InitialInformation:Mappable {
    var TituloGrid: String?
    var Descricao: String?
    var Img: String?
    var Relatoriopercentual: Int?
    var valor: Double?
    var DescricaoValor: String?
    var percentual: Int?
    var imgSmile: String?
    var questionId: Int?
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        TituloGrid    <- map["TituloGrid"]
        Descricao <- map["Descricao"]
        Img <- map["Img"]
        Relatoriopercentual <- map["Relatoriopercentual"]
        DescricaoValor <- map["DescricaoValor"]
        valor <- map["valor"]
        percentual <- map["percentual"]
        imgSmile <- map["imgSmile"]
        questionId <- map["QuestaoId"]
    }
}
