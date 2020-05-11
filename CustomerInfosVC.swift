//
//  CustomerInfosVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 3.05.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
class CustomerInfosVC: UIViewController {
    var db : Firestore!
    var locationText : String = ""
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getInfos()
        super.viewWillAppear(animated)
        locationLabel.text = locationText
    }
    override func viewWillDisappear(_ animated: Bool)
       {
           super.viewWillDisappear(animated)
           self.navigationController?.isNavigationBarHidden = false
                   if self.isMovingFromParent {
                       self.performSegue(withIdentifier: "toMenuCustomer", sender: nil)
                       self.dismiss(animated: true, completion: nil)
                   }
       }
    @IBAction func passwordResetClicked(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Sifrenizi mi Unuttunuz?", message: "Mail adresini giriniz", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Mail adresi giriniz"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Şifre sıfırla", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!.lowercased(), completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Sıfırlama hatalı", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Mail gönderildi", message: "Mailinizi kontrol edinizl", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
        
    }
    @IBAction func locationChngClicked(_ sender: Any) {
        
    }
    func getInfos() {
        db.collection("Customer").document((Auth.auth().currentUser?.email)!).addSnapshotListener { (snapshot,err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                if let email = snapshot?.data()!["E-mail"] as? String {
                    self.emailLabel.text = "E-mail : \(email)"
                }
                if let location = snapshot?.data()!["Location"] as? String {
                    self.locationLabel.text = "Location : \(location)"
                }
            }
        }
    }
    
}
