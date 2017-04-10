//
//  ImageCropViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

class ImageCropViewController: UIViewController {

    //MARK: Properties
    var didFinishCropping: ((UIImage) -> Void)?
   
    init(image:UIImage){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
