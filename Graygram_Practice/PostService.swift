//
//  PostService.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import Alamofire
import ObjectMapper

struct PostService{
    static func create(
        image: UIImage,
        message: String?,
        progress: @escaping (Progress) -> Void,
        completion: @escaping (DataResponse<Result<Post>>) -> Void
        ) {
        let urlString = "https://api.graygram.com/posts"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            ]
        Alamofire.upload(
            multipartFormData: { formData in
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }
                if let messageData = message?.data(using: .utf8) {
                    formData.append(messageData, withName: "message")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { result in
                switch result {
                case .success(let request, _, _): // Request 인코딩 성공
                    request // 실제 HTTP 요청
                        .validate(statusCode: 200..<400)
                        .responseJSON { response in
                            let response: DataResponse<Result<Post>> = response.flatMap { json in
                                if let post = Mapper<Post>().map(JSONObject: json) {
                                    return Result.success(post)
                                } else {
                                    return Result.failure(MappingError(from: json, to: Post.self))
                                }
                            }
                            completion(response)
                    }
                    
                case .failure(let error): // Request 인코딩 실패
                    let response = DataResponse<Result<Post>>(
                        request: nil,
                        response: nil,
                        data: nil,
                        result: .failure(error)
                    )
                    
                    completion(response)
                }
        }
        )
    }
    
    static func post(id: Int, completion: @escaping (DataResponse<Result<Post>>) -> Void) {
        let urlString = "https://api.graygram.com/posts/\(id)"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(urlString, method: .get, headers: headers)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                let response: DataResponse<Result<Post>> = response.flatMap { json in
                    if let post = Mapper<Post>().map(JSONObject: json) {
                        return .success(post)
                    } else {
                        return .failure(MappingError(from: json, to: Post.self))
                    }
                }
                completion(response)
        }
    }
    
    static func like(postID: Int, completion: @escaping (DataResponse<Result<Void>>) -> Void) {
        let urlString = "https://api.graygram.com/posts/\(postID)/likes"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(urlString, method: .post, headers: headers)
            .validate(statusCode: 200..<400)
            .responseData { response in
                let response: DataResponse<Result<Void>> = response.flatMap { _ in
                    return .success(Void())
                }
                completion(response)
        }
    }
    
    static func unlike(postID: Int, completion: @escaping (DataResponse<Void>) -> Void) {
        let urlString = "https://api.graygram.com/posts/\(postID)/likes"
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(urlString, method: .delete, headers: headers)
            .validate(statusCode: 200..<400)
            .responseData { response in
                let response: DataResponse<Void> = response.flatMap { _ in
                    return Result.success(Void())
                }
                completion(response)
        }
    }}
