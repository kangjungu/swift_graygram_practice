//
//  FeedService.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import Alamofire
import ObjectMapper

struct FeedService{
    
    static func feed(paging:Paging, completion: @escaping (DataResponse<Result<Feed>>) -> Void){
        let urlString:String
        switch paging{
        case .refresh:
            urlString = "https://api.graygram.com/feed"
        case.next(let nextURLString):
            urlString = nextURLString
        }
        
        Alamofire.request(urlString)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let response:DataResponse<Result<Feed>> = response.flatMap({ json in
                    if let feed = Mapper<Feed>().map(JSONObject: json){
                        return Result.success(feed)
                    }else{
                        return Result.failure(MappingError(from: json, to: Feed.self))
                    }
                })
                completion(response)
        }
        
    }
}
