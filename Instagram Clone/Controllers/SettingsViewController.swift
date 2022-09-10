//
//  SettingsViewController.swift
//  Instagram Clone
//
//  Created by mehmet on 3.09.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LogOutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
//            print("Error occured while sign out, please try again")
            let alert = UIAlertController(title: "Error", message: "Error occured while sign out, please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    
}
