//
//  RoleSelectedVCViewController.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 23.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit

class RoleSelectedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func segueToMain(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
  
    @IBAction func customerClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "loginCustomer", sender: self)
    }
    
    @IBAction func ownerClicked(_ sender: Any) {
        performSegue(withIdentifier: "loginOwner", sender: self)
    }
}
