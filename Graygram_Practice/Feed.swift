//
//  Feed.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import ObjectMapper

struct Feed:Mappable{
    var posts:[Post]?
    var nextURLString:String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.posts <- map["data"]
        self.nextURLString <- map["paging.next"]
    }
}
