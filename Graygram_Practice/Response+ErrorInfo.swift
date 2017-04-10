//
//  Response+ErrorInfo.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import Alamofire

extension DataResponse{
    func errorInfo()->(message:String?,field:String?)?{
        guard let data = self.data,
            let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
            let error = json["error"] as? [String: Any]
            else { return nil }
        
        let message = error["message"] as? String
        let field = error["field"] as? String
        return (message:message, field:field)
    }
}
