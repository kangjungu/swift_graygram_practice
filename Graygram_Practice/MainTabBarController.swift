//
//  MainTabBarViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    let feedViewController = FeedViewController()
    let settingsViewController = SettingsViewController()
    
    //업로드 버튼을 할 가짜 뷰 컨트롤러. 실제로 선택되지는 않습니다.
    let fakeUploadViewController = UIViewController().then{
        $0.tabBarItem.image = UIImage(named: "tab-upload")
        $0.tabBarItem.imageInsets.top = 5
        $0.tabBarItem.imageInsets.bottom = -5
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
        self.viewControllers = [
            UINavigationController(rootViewController: self.feedViewController),
            UINavigationController(rootViewController: self.settingsViewController),
            self.fakeUploadViewController
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Presenting
    fileprivate func presentImagePickerController(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
}

extension MainTabBarController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // `fakeUploadViewController` 탭을 선택하면 실제로 탭을 선택하는 대신 `PostEditorViewController`를 띄웁니다.
        if viewController === self.fakeUploadViewController{
            // === : 두 개체 참조가 동일한 인스턴스 객체를 참조하고 있는지 확인
            self.presentImagePickerController()
            return false
        }
        return true
    }
}

// MARK - UIImagePickerControllerDelegate

extension MainTabBarController:UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let garyscaledImage = selectedImage.grayscaled() else {
            return
        }
        
        let cropViewController = ImageCropViewController(image:garyscaledImage)
        cropViewController.didFinishCropping = { [weak cropViewController] croppedImage in
            let postEditorViewController = PostEditorViewController(image: croppedImage)
            cropViewController?.navigationController?.pushViewController(postEditorViewController, animated: true)
        }
        
        picker.pushViewController(cropViewController, animated: true)
    }
}

//MARK:UINavigationControolerDelegate

extension MainTabBarController:UINavigationControllerDelegate{
    
}
