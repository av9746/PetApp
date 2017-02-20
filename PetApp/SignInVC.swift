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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

  
    @IBOutlet weak var emailMenu: FancyView!
    @IBOutlet weak var facebookSignIn: FancyView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Anže found key")
            let currentUser = FIRAuth.auth()?.currentUser
            DataService.ds.REF_USERS.child((currentUser?.uid)!).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String
                if username == nil {
                    self.performSegue(withIdentifier: "goToEditProfile", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "goToNewsFeed", sender: nil)
                }
            })
        } else {
            print("Anže key wasnt found")
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Anže: Unable to authenticate with firebise \(error)")
            } else {
                print("Anže: Firebase authentication succseeded")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.signInComplete(id: user.uid, userData: userData)
                    print("Anže: HHHHHH\(userData)")
                }
            }
        })
    }
    
    func signInComplete(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createfirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Anže: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToEditProfile", sender: nil)
        
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
    
    @IBAction func emailSignInTapped(_ sender: Any) {
    
        emailMenu.isHidden = false
        facebookSignIn.isUserInteractionEnabled = false
        
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        if let email = emailTextField.text, let psw1 = passwordTextField.text, let psw2 = reenterPasswordTextField.text {
            if psw1 == psw2 {
                FIRAuth.auth()?.signIn(withEmail: email, password: psw1, completion: { (user, error) in
                    if error == nil {
                        print("Anže: Succsesfully signed in with email user")
                        if let user = user {
                            let userData = ["provider": user.providerID]
                            self.signInComplete(id: user.uid, userData: userData)
                        }
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: psw1, completion: { (user, error) in
                            if error != nil {
                                print("Anže: Uneable to authenticate with email")
                            } else {
                                print("Anže: Succsesfully authenticated with email, creating new firebase user")
                                if let user = user {
                                    let userData = ["provider": user.providerID]
                                    self.signInComplete(id: user.uid, userData: userData)
                                    print("Anže:HHHHHHH \(userData)")
                                }
                            }
                        })
                    }
                })
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        emailMenu.isHidden = true
        view.endEditing(true)
        facebookSignIn.isUserInteractionEnabled = true
    }
    
}
