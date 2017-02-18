//
//  SignInVC.swift
//  PetApp
//
//  Created by Anze Vavken on 17/02/2017.
//  Copyright © 2017 VavkenApps. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Anže: Unable to authenticate with firebise \(error)")
            } else {
                print("Anže: Firebase authentication succseeded")
            }
        })
    }
    
    
    @IBAction func facebookTapped(_ sender: Any) {
        let facebookLoginManager = FBSDKLoginManager()
        
        facebookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("ANŽE:uneable to authanticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("ANŽE: user canceled authentication")
            } else {
                print("ANŽE: Succsesfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
}
