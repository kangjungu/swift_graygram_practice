//
//  UserImageView+Photo.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func setImage(with photoID:String?, placeholder:UIImage? = nil,size:PhotoSize){
        guard let photoID = photoID else{
            self.image = placeholder
            return
        }
        
        let url = URL(string: "https://graygram.com/photos/\(photoID)/\(size.pixel)x\(size.pixel)")
        //kf : URL를 이용한 이미지를 불러온 때 쓰는 라이브러리
        self.kf.setImage(with: url,placeholder:placeholder)
    }
}
