//
//  OwnerRegisterVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 24.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
class OwnerRegisterVC: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    var db : Firestore!
    var locationText : String = ""
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = .systemIndigo
        db = Firestore.firestore()
        //     locationLabel.text = locationText
        super.viewDidLoad()
        viewWillAppear(true)
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationLabel.text = locationText
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func locationClicked(_ sender: Any) {
    }
    @IBAction func registerClicked(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (data, error) in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
            } else {
                
                self.db.collection("Owner").document(self.emailText.text!).setData([
                    
                    "E-mail" : self.emailText.text!,
                    "Password" : self.passwordText.text!,
                    "Location" : self.locationText
                    
                    ])
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                self.performSegue(withIdentifier: "toMenu", sender: nil)
            }
        }
    }
    func makeAlert(titleInput : String,messageInput : String) {
        let alert=UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
}
