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
    
    var plateNumber : Int = 0
    var platei : Int = 0
    var plateCount : String = ""
    var foodName : String = ""
    var imageData = UIImageView()
    var dateText : String = ""
    var db : Firestore!
    var emailText : String = ""
    override func viewDidLoad() {
       // UserDefaults.standard.removeObject(forKey: "count")
        super.viewDidLoad()
        db = Firestore.firestore()
        imageView.image = imageData.image
        plateCountNumber.text = "Tabak sayısı : \(plateCount)"
        foodNameLabel.text = foodName
        dateLabel.text = dateText
        
       if let myDouble = NumberFormatter().number(from: plateCount)?.doubleValue {
        stepperValue.maximumValue = myDouble
        stepperValue.minimumValue = 1
        }
    }
    @IBAction func stepperClicked(_ sender: Any) {
        
        tabakCount.text = "\(Int(stepperValue.value))"
    }
    @IBAction func sepeteEkleClicked(_ sender: Any) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MenuCustomerVC")as? MenuCustomerVC
        resultVC?.userArray.removeAll()
        resultVC?.articles.removeAll()
        self.i = UserDefaults.standard.integer(forKey: "count")
        print("PLATENUMBER:\(self.plateNumber)")
        let ref = db.collection("Cart").document((Auth.auth().currentUser?.email)!)
        ref.getDocument { (snapshot, err) in
            guard let _snapshot = snapshot else {return}
            if !_snapshot.exists {
                
                ref.setData([
                    
                    "Foodname\(self.i-1)" : self.foodName,
                    "Platecount\(self.i-1)" : self.plateCount,
                    "Owneremail" : self.emailText,
                    "i\(self.i-1)" : self.i-1
                    
               ])
            } else {
                ref.updateData([
                "Foodname\(self.i-1)" : self.foodName,
                "Platecount\(self.i-1)" : self.plateCount,
                "Owneremail" : self.emailText,
                "i\(self.i-1)" : self.i-1
                ])
            }
        }
        self.i = self.i + 1
        UserDefaults.standard.set(self.i, forKey: "count")
        self.navigationController?.pushViewController(resultVC!, animated: true)
    }
}
