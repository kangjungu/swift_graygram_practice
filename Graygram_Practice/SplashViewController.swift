//
//  ViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 6..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserService.me(){
            response in
            switch response.result{
            case .success(let value):
                print("내 프로필 정보 받아오기 성공! ",value.value)
                AppDelegate.instance?.presentMainScreen()
            case .failure(let error):
                print("내 프로필 정보 받아오기 실패 ㅠㅠ",error)
                AppDelegate.instance?.presentLoginScreen()
                
            }
            
        }
    }


}

