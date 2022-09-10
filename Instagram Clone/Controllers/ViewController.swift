//
//  ViewController.swift
//  Instagram Clone
//
//  Created by mehmet on 2.09.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if userNameTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { dataResult, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "An error occured while logging in")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Email or password field should not be empty!")
        }
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        if userNameTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: userNameTextField.text!, password: passwordTextField.text!) { dataResult, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "An error occured while processing")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "No Username/Password?")
        }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

