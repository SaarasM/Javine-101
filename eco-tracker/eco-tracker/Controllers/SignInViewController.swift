//
//  SignInViewController.swift
//  eco-tracker
//
//  Created by Benjamin Searle on 19/01/2020.
//  Copyright © 2020 Benjamin Searle. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    @IBAction func didPressStart(_ sender: Any) {
        if let testUser = GIDSignIn.sharedInstance()?.currentUser {
            print(testUser)
            
            self.performSegue(withIdentifier: "Segue.SignIn", sender: self)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
