//
//  CartShowVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 13.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase

class CartShowVC: UIViewController {
    @IBOutlet weak var stepperValue: UIStepper!
    @IBOutlet weak var tabakCount: UILabel!
    @IBOutlet weak var plateCountNumber: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    var i : Int = 0
    var imageURL : String = ""
    var plateNumber : Int = 0
    var platei : Int = 0
    var plateCount : String = ""
    var foodName : String = ""
    var imageData = UIImageView()
    var dateText : String = ""
    var emailText : String = ""
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = imageData.image
        plateCountNumber.text = "Tabak sayısı : \(plateCount)"
        foodNameLabel.text = foodName
        dateLabel.text = dateText
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let myDouble = NumberFormatter().number(from: plateCount)?.doubleValue {
            stepperValue.maximumValue = myDouble
            stepperValue.minimumValue = 1
        }
    }
    @IBAction func stepperClicked(_ sender: Any) {
        
        tabakCount.text = "\(Int(stepperValue.value))"
    }
    @IBAction func sepeteEkleClicked(_ sender: Any) {
        let db  = Firestore.firestore()
        
        db.collection("Cart").document((Auth.auth().currentUser?.email!)!).collection("Cart").document().setData([
            "imageURL" : self.imageURL,
            "Foodname" : self.foodName,
            "Platecount" :tabakCount.text,
            "Owneremail" :self.emailText,
        ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Cart Document successfully written!")
            }
        }
        self.performSegue(withIdentifier: "toMenuCustomer", sender: nil)
    }
}
