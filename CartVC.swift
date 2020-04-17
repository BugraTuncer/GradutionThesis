//
//  CartVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 13.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
class CartVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var db : Firestore!
    var i : Int = 0
    var cartItems = [CartItem]()
    var cartItemsCell = [CartItemCell]()
    var singeltonArray = [SingeltonDelete]()
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getDocuments()
        self.tableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        doControls()
        self.tableView.reloadData()
    }
    func getDocuments() {
        
        let ref=db.collection("Cart").document((Auth.auth().currentUser?.email)!)
        ref.getDocument { (snapshot, err) in
            if err != nil {
                print(err?.localizedDescription)
            }else {
                while snapshot?.data()!["Foodname\(self.i)"] != nil {
                    var cartItem = CartItem()
                    let namefood = snapshot?.data()!["Foodname\(self.i)"] as? String
                    let platecount = snapshot?.data()!["Platecount\(self.i)"] as? String
                    let owneremail = snapshot?.data()!["Owneremail"] as? String
                    let iNumber = snapshot?.data()!["i\(self.i)"] as? Int
                   
                    cartItem.iNumber = iNumber!
                    cartItem.ownerEmail = owneremail!
                    cartItem.foodName = namefood!
                    cartItem.plateNumber = platecount!
                    self.cartItems.append(cartItem)
                    self.i = self.i + 1
                }
            }
        }
    }
    func doControls() {
        
        for x in cartItems {
            let ref=db.collection("Owner").document(x.ownerEmail)
                    ref.getDocument { (snapshot, err) in
                        print("ASDASDSA")
                        if err != nil {
                            print("ASDASDSAD")
                            print(err?.localizedDescription)
                        }else {
                            while snapshot?.data()!["nameFood\(self.i)"] != nil {
                                var singeltonDelete = SingeltonDelete()
                                let namefood = snapshot?.data()!["nameFood\(self.i)"] as? String
                                singeltonDelete.text=namefood!
                                self.singeltonArray.append(singeltonDelete)
                                self.i = self.i + 1
                            }
                        }
                    }
            var cellItem = CartItemCell()
            cellItem.nameFood = x.foodName
            cellItem.plateCount = x.plateNumber
            cellItem.ownerEmail = x.ownerEmail
            cellItem.iNumber = x.iNumber
            cartItemsCell.append(cellItem)
        }
    }
    @IBAction func siparisVerClicked(_ sender: Any) {
        
        for x in cartItemsCell {
            print(x.ownerEmail)
            if Int(x.plateCount) == 0 || Int(x.plateCount) == 1 {
                if x.iNumber == 0 {
                    for y in 0..<singeltonArray.count {
                        db.collection("Owner").document(x.ownerEmail).updateData([
                            
                            "Platecount\(y)" : "Platecount\(y-1)",
                            "Day\(y)" : "Day\(y-1)",
                            "Hour\(y)" : "Hour\(y-1)",
                            "Minute\(y)" : "Minute\(y-1)",
                            "imageURL\(y)" : "imageURL\(y-1)",
                            "nameFood\(y)" : "nameFood\(y-1)"
                            
                        ])
                    }
                    db.collection("Owner").document(x.ownerEmail).updateData([
                        
                        "Platecount\(x.iNumber+1)" : FieldValue.delete(),
                        "Day\(x.iNumber+1)" : FieldValue.delete(),
                        "Hour\(x.iNumber+1)" : FieldValue.delete(),
                        "Minute\(x.iNumber+1)" : FieldValue.delete(),
                        "imageURL\(x.iNumber+1)" : FieldValue.delete(),
                        "nameFood\(x.iNumber+1)" : FieldValue.delete()
                        
                    ])
                    db.collection("Cart").document((Auth.auth().currentUser?.email!)!).delete()
                    let storyboard3 = UIStoryboard (name: "Main", bundle: nil)
                                      let resultVC3 = storyboard3.instantiateViewController(withIdentifier: "CartShowVC")as? CartShowVC
                                       resultVC3?.i = 0
                } else {
                    db.collection("Owner").document(x.ownerEmail).updateData([
                        
                        "Platecount\(x.iNumber+1)" : FieldValue.delete(),
                        "Day\(x.iNumber+1)" : FieldValue.delete(),
                        "Hour\(x.iNumber+1)" : FieldValue.delete(),
                        "Minute\(x.iNumber+1)" : FieldValue.delete(),
                        "imageURL\(x.iNumber+1)" : FieldValue.delete(),
                        "nameFood\(x.iNumber+1)" : FieldValue.delete()
                        
                    ])
                    for z in x.iNumber..<singeltonArray.count {
                                          
                                          db.collection("Owner").document(x.ownerEmail).updateData([
                                              
                                              "Platecount\(z+1)" : "Platecount\(z-1)",
                                              "Day\(z+1)" : "Day\(z-1)",
                                              "Hour\(z+1)" : "Hour\(z-1)",
                                              "Minute\(z+1)" : "Minute\(z-1)",
                                              "imageURL\(z+1)" : "imageURL\(z-1)",
                                              "nameFood\(z+1)" : "nameFood\(z-1)"
                                              
                                          ])
                                      }
                    db.collection("Cart").document((Auth.auth().currentUser?.email!)!).delete()
                   let storyboard2 = UIStoryboard (name: "Main", bundle: nil)
                   let resultVC2 = storyboard2.instantiateViewController(withIdentifier: "CartShowVC")as? CartShowVC
                    resultVC2?.i = 0
                    
                }
            } else {
                
                db.collection("Owner").document(x.ownerEmail).updateData([
                    "Platecount\(x.iNumber+1)" : Int(x.plateCount)!-1,
                ])
                db.collection("Cart").document((Auth.auth().currentUser?.email!)!).delete()
            }
        }
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MenuCustomerVC")as? MenuCustomerVC
        resultVC?.userArray.removeAll()
        resultVC?.articles.removeAll()
        navigationController?.pushViewController(resultVC!, animated: true)
    }
}
extension CartVC : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemsCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartitem = cartItemsCell[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell{
            cell.nameFood.text =    cartitem.nameFood
            cell.plateCount.text = "Tabak sayısı : \(cartitem.plateCount)"
            return cell
        }
        return UITableViewCell()
    }
    
}
