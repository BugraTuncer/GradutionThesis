//
//  MenuVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 4.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import SDWebImage
class MenuCustomerVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var articles = [ArticleItem]()
    var userArray = [OwnerUser]()
    var foodArray = [FoodOwnerUser]()
    var customerLocation : String = ""
    var db : Firestore!
    var i : Int = 1
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        let menuItem = UIButton()
        menuItem.setImage(UIImage(named: "menu"), for: UIControl.State())
        menuItem.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuItem.addTarget(self, action: #selector(menuButtonClicked(_:)), for: .touchUpInside)
        let menuItem2 = UIBarButtonItem()
        menuItem2.customView = menuItem
        self.navigationItem.leftBarButtonItem = menuItem2
    }
    override func viewWillAppear(_ animated: Bool) {
        getOwnerDocuments()
        getCustomerLocation()
        self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        doControls()
        self.collectionView.reloadData()
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "menuSegue", sender: self)
        
    }
    @IBAction func sepetClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toCartVC", sender: self)
    }
    
    func getOwnerDocuments() {
        db.collection("Owner").addSnapshotListener { (snapshot, err) in
            if err != nil {
                print("Get document has failed")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userArray.removeAll()
                    for document in snapshot!.documents {
                        var user = OwnerUser()
                        if let location = document.get("Location") as? String {
                            user.location = location
                        }
                        if let email = document.get("E-mail") as? String {
                            user.email = email
                            self.db.collection("Owner").document(email).collection("Food").addSnapshotListener { (snapshotX, err) in
                                
                                if err != nil {
                                    print(err?.localizedDescription)
                                } else {
                                    if snapshotX?.isEmpty != true && snapshotX != nil {
                                        self.foodArray.removeAll()
                                        for foods in snapshotX!.documents {
                                            var foodOwnerUser = FoodOwnerUser()
                                            if let plateCount = foods.get("Platecount") as? Int {
                                                foodOwnerUser.plateCount = plateCount
                                               
                                            }
                                            if let imageURL = foods.get("imageURL") as? String {
                                                foodOwnerUser.imageUrl = imageURL
                                            }
                                            if let nameFood = foods.get("nameFood") as? String {
                                                
                                                foodOwnerUser.nameFood = nameFood
                                            }
                                            if let day = foods.get("Day") as? Int {
                                                foodOwnerUser.day = day
                                            }
                                            if let hour = foods.get("Hour") as? Int {
                                                foodOwnerUser.hour = hour
                                            }
                                            if let minute = foods.get("Minute") as? Int {
                                                foodOwnerUser.minute = minute
                                            }
                                            foodOwnerUser.email = user.email
                                            foodOwnerUser.Location = user.location
                                            self.foodArray.append(foodOwnerUser)
                                        }
                                    }
                                  
                                }
                            }
                        }
                       self.userArray.append(user)
                            }
                        }
                    }
                }
        self.collectionView.reloadData()
            }
    func getCustomerLocation() {
        
        db.collection("Customer").document((Auth.auth().currentUser?.email)!).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Get customer document has failed")
            } else {
                if let location = snapshot?.get("Location") as? String {
                    self.customerLocation = location
                }
            }
        }
    }
    
   
    func doControls(){
        let date = NSDate()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.day,.hour,.minute], from: date as Date)
        articles.removeAll()
        for x in foodArray {
            if x.Location == customerLocation {
                var articlesModel = ArticleItem()
                articlesModel.hour = x.hour
                articlesModel.minute = x.minute
                articlesModel.nameFood = x.nameFood
                articlesModel.plateCount = x.plateCount
                articlesModel.imageURL = x.imageUrl
                articlesModel.emailText = x.email
                articles.append(articlesModel)
            }
            
        }
    }
}
extension MenuCustomerVC : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let article = articles[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toCell", for: indexPath) as? ArticleCollectionViewCell {
            let url = URL(string: article.imageURL)!
           
            cell.foodDate.adjustsFontSizeToFitWidth = true
            cell.foodDate.minimumScaleFactor = 0.5
            cell.plateCount.text = "Tabak sayısı : \(article.plateCount)"
            cell.imageView.sd_setImage(with: url)
            cell.foodName.text = "Yemek ismi : \(article.nameFood)"
            cell.foodDate.text = "Kalan sure :\(article.hour) saat \(article.minute) dakika"
            cell.cartClicked.tag = indexPath.row
            cell.cartClicked.addTarget(self, action: #selector(self.cartClicked(_:)), for: .touchUpInside)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            
    }
    @objc func cartClicked (_ sender: UIButton){
        let article = articles[sender.tag]
        let url = URL(string: article.imageURL)!
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "CartShowVC")as? CartShowVC
        resultVC?.imageURL = article.imageURL
        resultVC?.imageData.sd_setImage(with: url)
        resultVC?.emailText = article.emailText
        resultVC?.foodName = article.nameFood
        resultVC?.dateText = "Kalan saat : \(article.hour) ve Dakika : \(article.minute)"
        resultVC?.plateCount = String(article.plateCount)
        self.navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    
}
