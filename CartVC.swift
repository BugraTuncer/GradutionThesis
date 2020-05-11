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
    var stopCount = 0
    var db : Firestore!
    var ref : DatabaseReference!
    var i : Int = 0
    var cartItems = [CartItem]()
    var deleteArray = [DeleteCart]()
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        ref = Database.database().reference()
        db = Firestore.firestore()
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getDocuments()
        self.tableView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        delete()
    }
    func getDocuments() {
        
        db.collection("Cart").document((Auth.auth().currentUser?.email)!).collection("Cart").addSnapshotListener { (snapshot, err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.cartItems.removeAll()
                    for document in snapshot!.documents {
                        var cartItem = CartItem()
                        if let namefood = document.get("Foodname") as? String {
                            cartItem.foodName = namefood
                        }
                        if let plateNumber = document.get("Platecount") as? String {
                            cartItem.plateNumber = plateNumber
                        }
                        if let ownerEmail = document.get("Owneremail") as? String {
                            cartItem.ownerEmail = ownerEmail
                        }
                        if let imageURL = document.get("imageURL") as? String {
                            cartItem.imageURL = imageURL
                        }
                        self.cartItems.append(cartItem)
                    }
                }
            }
        }
    }
    @IBAction func siparisVerClicked(_ sender: Any) {
        self.db.collection("Owner").addSnapshotListener { (snapshot, err) in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        if let ownerEmail = document.get("E-mail") as? String {
                            
                            self.db.collection("Owner").document(ownerEmail).collection("Food").getDocuments() { (snapshotY,err) in
                                
                                if snapshotY?.isEmpty != true && snapshotY != nil {
                                    for foods in snapshotY!.documents {
                                        for x in self.cartItems {
                                            
                                            if let plateCountX = foods.get("Platecount") as? Int {
                                                if (plateCountX - Int(x.plateNumber)!) <= 0 {
                                                if let foodNameX = foods.get("nameFood") as? String {
                                                    if foodNameX == x.foodName{
                                                        self.db.collection("Owner").document(ownerEmail).collection("Food").document(foodNameX).delete()
                                                        let storage = Storage.storage()
                                                        let storageRef = storage.reference(forURL: x.imageURL)
                                                        let imageRef = storageRef.child("Media")
                                                        
                                                        imageRef.delete { (err) in
                                                            if err != nil {
                                                                print("Error delete image")
                                                            } else {
                                                                print("Delete image succesfully")
                                                            }
                                                        }
                                                    }
                                                }
                                                } else {
                                                    if let foodNameY = foods.get("nameFood") as? String {
                                                        if foodNameY == x.foodName{
                                                            self.db.collection("Owner").document(ownerEmail).collection("Food").document(foodNameY).updateData([
                                                                "Platecount" : (plateCountX -  Int(x.plateNumber)!)
                                                                
                                                            ])
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            for x in self.cartItems {
                self.db.collection("OwnerCart").document().setData([
                    "Foodname" : x.foodName,
                    "Platenumber" : x.plateNumber,
                    "CustomerEmail" : Auth.auth().currentUser?.email,
                    "imageURl" : x.imageURL
                ])
            }
            self.db.collection("Cart").document((Auth.auth().currentUser?.email)!).collection("Cart").addSnapshotListener{ (snapshot, err) in
                if err != nil {
                    print (err?.localizedDescription)
                } else {
                    if snapshot?.isEmpty != true && snapshot != nil {
                        for document in snapshot!.documents {
                            var deleteItem = DeleteCart()
                            deleteItem.autoID = document.documentID
                            self.deleteArray.append(deleteItem)
                        }
                        
                    }
                }
            }
            self.delete()
            //     self.cartItems.removeAll()
        }
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MenuCustomerVC")as? MenuCustomerVC
        resultVC?.userArray.removeAll()
        resultVC?.articles.removeAll()
        resultVC?.foodArray.removeAll()
        self.navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    func delete() {
        for x in self.deleteArray {
            let docRef = self.db.collection("Cart").document((Auth.auth().currentUser?.email)!).collection("Cart").document(x.autoID)
            docRef.delete()
        }
    }
    
    //    func deleteOwner() {
    //        for z in emailArray {
    //            for y in ownerItemsArray {
    //                for x in cartItems {
    //                    if y.nameFood == x.foodName {
    //                        self.db.collection("Owner").document(z.ownerEmail).collection("Food").document(y.nameFood).delete()
    //                        let storage = Storage.storage()
    //                        let storageRef = storage.reference(forURL: x.imageURL)
    //                        let imageRef = storageRef.child("Media")
    //
    //                        imageRef.delete { (err) in
    //                            if err != nil {
    //                                print("Error delete image")
    //                            } else {
    //                                print("Delete image succesfully")
    //                            }
    //                        }
    //                    } else {
    //                        self.db.collection("Owner").document(z.ownerEmail).collection("Food").document(y.nameFood).updateData([
    //
    //                            "Platecount" : (y.plateCount -  Int(x.plateNumber)!)
    //
    //                        ])
    //
    //                    }
    //                }
    //            }
    //        }
    //    }
}
extension CartVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartitem = cartItems[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CartTableViewCell{
            cell.nameFood.text =  cartitem.foodName
            cell.plateCount.text = "Tabak sayısı : \(cartitem.plateNumber)"
            return cell
        }
        return UITableViewCell()
    }
    
}
