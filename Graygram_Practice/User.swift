//
//  user.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import ObjectMapper

struct User:Mappable{
    var id:Int!
    var username:String!
    var photoID:String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.username <- map["username"]
        self.photoID <- map["photo.id"]
    }
}
