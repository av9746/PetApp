//
//  EditProfileVC.swift
//  PetApp
//
//  Created by Anze Vavken on 19/02/2017.
//  Copyright © 2017 VavkenApps. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    @IBAction func saveBtnTapped(_ sender: Any) {
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        if let username = usernameField.text, usernameField.text != "" {
            DataService.ds.REF_USERS.child((currentUser?.uid)!).updateChildValues(["username": username])
            
        }
            
    }

}
