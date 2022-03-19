//
//  LoginViewController.swift
//  Twitter
//
//  Created by yug brahmbhatt on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            
            // when the user loggedin, set the value of userLoggedIn to true
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { (Error) in
            print("Could not log in!")
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // checking if userLoggedIn is true
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


  

        
    }

    
