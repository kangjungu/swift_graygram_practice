//
//  UserService.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//


import Alamofire
import ObjectMapper

struct UserService{
    
    static func me(_ completion: @escaping (DataResponse<Result<User>>) -> Void) {
        let urlString = "https://api.graygram.com/me"
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { response in

                let response: DataResponse<Result<User>> = response.flatMap { json in
                    if let user = Mapper<User>().map(JSONObject: json) {
                        return Result.success(user)
                    } else {
                        let error = MappingError(from: json, to: User.self)
                        return Result.failure(error)
                    }
                }
                completion(response)
            })
    }
    
    
}
