//
//  ViewController2.swift
//  FirebaseProject
//
//  Created by jinn on 29/10/2022.
//

import UIKit
import Firebase

class ViewController2: UIViewController {

    @IBOutlet var PasswordTFSignUp: UITextField!
    @IBOutlet var emailTFSignUp: UITextField!
    @IBOutlet var nameTFSignUp: UITextField!
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailTFSignUp.text , let password = PasswordTFSignUp.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { res, error in
            if error == nil {
                print("Success Register")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ROOMS")as?ROOMS{
                guard let userID = res?.user.uid , let name = self.nameTFSignUp.text else {return}
                let ref = Database.database().reference()
                let user = ref.child("USERS").child(userID)
                let dataArray:[String:Any] = ["User Name":name]
                user.setValue(dataArray)
                self.present(vc, animated: true, completion: nil)
                }
                }
        }
    }
    
}
