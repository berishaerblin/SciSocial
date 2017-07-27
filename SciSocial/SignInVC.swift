//
//  SignInVC.swift
//  SciSocial
//
//  Created by Erblin Berisha on 7/24/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    @IBAction func facebookBtnTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
                
            }
        }
    }

    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (user, error) in
            if (error != nil) {
                print("Unable to sign in with firebase")
            } else {
                print("Sucessful sign in with firebase")
                if let user = user {
                    let userData = ["provider" : credential.provider]
                    self?.completeSignIn(id: user.uid, userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: {[weak self] (user, error) in
                if error == nil {
                    print("Blinnky: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self?.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Blinnky: Unable to authenticate with Firebase using email")
                        } else {
                            print("Blinnky: Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self?.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Blinnky: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

