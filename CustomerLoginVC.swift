//
//  CustomerVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 23.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase

class CustomerLoginVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = .systemIndigo
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func continueClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: (emailText.text?.lowercased())!, password: passwordText.text!) { (data, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error ! ", messageInput:error?.localizedDescription ?? "Error")
                
            } else {
                self.emailText.text = ""
                self.passwordText.text = ""
                self.performSegue(withIdentifier: "toMenu", sender: nil)
            }
        }
    
        
    }
    @IBAction func registerClicked(_ sender: Any) {
        
    }
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
