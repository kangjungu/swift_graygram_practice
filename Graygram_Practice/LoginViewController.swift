//
//  LoginViewController.swift
//  Graygram_Practice
//
//  Created by JHJG on 2017. 4. 7..
//  Copyright © 2017년 KangJungu. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    //MARK: UI
    
    fileprivate let usernameTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Username"
        //자동 교정을 할지 결정하는 것
        $0.autocorrectionType = .no
        //입력한 문자를 자동으로 대문자로 만들지 결정하는 것
        $0.autocapitalizationType = .none
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    fileprivate let passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Password"
        //텍스트를 *로 변경해줌 (비밀번호처럼)
        $0.isSecureTextEntry = true
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    fileprivate let loginButton = UIButton().then{
        $0.backgroundColor = $0.tintColor
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitle("Login",for:.normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
        self.usernameTextField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        self.loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        self.view.addSubview(self.usernameTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.loginButton)
        
        self.usernameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(35)
        }
        
        self.passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(self.usernameTextField)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(15)
            make.left.right.equalTo(self.usernameTextField)
            make.height.equalTo(40)
        }
    }
    
    func textFieldDidChangeText(_ textField:UITextField){
        textField.backgroundColor = .white
    }
    
    func loginButtonDidTap(){
        guard let username = self.usernameTextField.text, !username.isEmpty else{
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            return
        }
        
        self.usernameTextField.isEnabled = false
        self.passwordTextField.isEnabled = false
        self.loginButton.isEnabled = false
        self.loginButton.alpha = 0.4
        
        AuthService.login(username: username, password: password) { (response) in
            switch response.result{
                case .success:
                AppDelegate.instance?.presentMainScreen()
            case .failure(let error):
                print("로그인 실패 ",error)
                self.usernameTextField.isEnabled = true
                self.passwordTextField.isEnabled = true
                self.loginButton.isEnabled = true
                self.loginButton.alpha = 1
                
                switch response.errorInfo()?.field{
                case .some("username"):
                    self.usernameTextField.becomeFirstResponder()
                    self.usernameTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                case .some("password"):
                    self.passwordTextField.becomeFirstResponder()
                    self.passwordTextField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
                default:
                    break;
                }
            }
        }
    }


}
