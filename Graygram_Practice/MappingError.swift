//
//  MappingError.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

struct MappingError:Error,CustomStringConvertible{
    
    let description: String
    
    init(from:Any?,to:Any.Type) {
        self.description = "Failed to map \(from) to \(to)"
    }
}
