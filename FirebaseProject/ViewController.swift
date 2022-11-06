//
//  ViewController.swift
//  FirebaseProject
//
//  Created by jinn on 29/10/2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var passwordTFSignIn: UITextField!
    @IBOutlet var emailTFSignIn: UITextField!
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        if let vc2 = storyboard?.instantiateViewController(withIdentifier: "ViewController2")as?ViewController2{
            present(vc2, animated: true, completion: nil)
        }
    }
    func displayError(message : String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func signInButton(_ sender: UIButton) {
        
        guard let email = emailTFSignIn.text , let password = passwordTFSignIn
                .text else {return}
        if email.isEmpty == true || password.isEmpty == true {
            displayError(message: "Is Empty")
        } else{
            
        Auth.auth().signIn(withEmail: email, password: password) { au, error in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            } else {
                self.displayError(message: "ERROR")
            }
        }
        }
        
    }
}

