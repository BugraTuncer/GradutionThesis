//
//  MenuOwnerVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 5.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit

class MenuOwnerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuItem = UIButton()
        menuItem.setImage(UIImage(named: "menu"), for: UIControl.State())
        menuItem.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuItem.addTarget(self, action: #selector(menuButtonClicked(_:)),for: .touchUpInside)
        
        let menuItem2 = UIBarButtonItem()
        menuItem2.customView = menuItem
        self.navigationItem.leftBarButtonItem = menuItem2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toMenu", sender: self)
    }
    
    @IBAction func addFoodClicked(_ sender: Any) {
        
    }
    
}
