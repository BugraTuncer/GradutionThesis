//
//  RoleSelectedVCViewController.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 23.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class RoleSelectedVC: UIViewController {
    
    var db : Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .systemIndigo
        db = Firestore.firestore()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func customerClicked(_ sender: Any) {
       
        
    }
    @IBAction func ownerClicked(_ sender: Any) {
       
    }
}
