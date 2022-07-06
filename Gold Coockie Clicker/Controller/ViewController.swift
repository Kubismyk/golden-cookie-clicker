//
//  ViewController.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 26.02.22.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var mainNameLabel: UILabel!
    
    @IBOutlet weak var continueWithFacebookButton: UIButton!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }
    
    func setupDesign(){
        mainNameLabel.dropShadowAndFont(fontSize: 65, shadowRadius: 10, shadowOpacity: 0.25, shadowX: 0, shadowY: 4, fontFamily: "Lobster")
        continueWithFacebookButton.buttonFontAndSize(fontFamily: "Lobster", fontSize: 28)
    }
    
    func validateData() -> String? {
        func showErrorTwo(_ message: String) {
            print(message)
        }
        if userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                          
                return "Please fill in all line"
            
        }
        return nil
    }

    
    @IBAction func registerButton(_ sender: Any) {
        
        let error = validateData()
        if error != nil{
            print("\(error)")
        }else {
            let username = userNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            

            
            
            // create user
            Auth.auth().createUser(withEmail: username, password: password) { (result, err) in
                // check for errors
                
                if let err = err {
                    // error occuried
                    print("error while creating user")
                }else {
                    self.transitionToHome()
                    // user was created succesfully,store username
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData([
                        "username":self.userNameField.text!
                        //"password":self.passwordField.text!
                        
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func loginWithFacebook(_ sender: UIButton) {
        transitionToHome()
    }
    
    func transitionToHome(){
        let storyBoard = UIStoryboard(name: "Cookie", bundle: nil)
        let tabViewController =
        storyBoard.instantiateViewController(withIdentifier: "CookieViewController") as? CookieViewController
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}

