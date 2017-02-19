//
//  NewsFeedVC.swift
//  PetApp
//
//  Created by Anze Vavken on 19/02/2017.
//  Copyright © 2017 VavkenApps. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class NewsFeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func signOutBtnTapped(_ sender: Any) {
        let removeSuccsefully = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("Anže: Keychain removed\(removeSuccsefully)")
        try? FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
        
    }

}
