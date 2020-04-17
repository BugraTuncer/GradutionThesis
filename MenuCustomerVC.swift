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
        userArray.removeAll()
        articles.removeAll()
        self.performSegue(withIdentifier: "toCartVC", sender: self)
    }
    
    func getOwnerDocuments() {
        
        db.collection("Owner").addSnapshotListener { (snapshot, err) in
            if err != nil {
                print("Get document has failed")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        var user = OwnerUser()
                        if let location = document.get("Location") as? String {
                            user.location = location
                        }
                        if (document.get("Day1") != nil) {
                            while (document.get("Day\(self.i)")) != nil {
                                if let dateDay = document.get("Day\(self.i)") as? Int {
                                    user.day.append(dateDay)
                                }
                                if let dateHour = document.get("Hour\(self.i)") as? Int {
                                    user.hour.append(dateHour)
                                }
                                if let dateMinute = document.get("Minute\(self.i)") as? Int {
                                    user.minute.append(dateMinute)
                                }
                                if let imageURL = document.get("imageURL\(self.i)") as? String {
                                    user.imageUrl.append(imageURL)
                                }
                                if let foodName = document.get("nameFood\(self.i)") as? String {
                                    user.nameFood.append(foodName)
                                }
                                if let plateCount = document.get("Platecount\(self.i)") as? Int {
                                    user.plateNumber.append(self.i)
                                    user.plateCount.append(plateCount)
                                }
                                if let emailText = document.get("E-mail") as? String {
                                    user.email = emailText
                                }
                                self.i = self.i + 1
                            }
                            self.i = 1
                            self.userArray.append(user)
                        }
                    }
                }
            }
        }
    }
    func getCustomerLocation() {
        
        db.collection("Customer").document((Auth.auth().currentUser?.email)!).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Get customer document has failed")
            } else {
                if let location = snapshot?.get("Location") as? String {
                    print("Customer Location : \(location)")
                    self.customerLocation = location
                }
            }
        }
    }
    
   
    func doControls(){
        let date = NSDate()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.day,.hour,.minute], from: date as Date)
        
        for x in userArray{
            if customerLocation == x.location {
                print(x.nameFood)
                for y in 0..<x.day.count {
                    var articleUser = ArticleItem()
                    if currentComponents.day! - x.day[y] == 1 && currentComponents.hour! - x.hour[y] == 0 && currentComponents.minute! - x.minute[y] == 0 {
                        print("delete")
                    }else{
                        articleUser.emailText = x.email
                       // if x.plateNumber[y] > 0 {
                        articleUser.plateNumber = x.plateNumber[y]
                       // }
                        articleUser.plateCount = x.plateCount[y]
                        articleUser.imageURL = x.imageUrl[y]
                        articleUser.nameFood = x.nameFood[y]
                        articleUser.hour = abs(currentComponents.hour! - x.hour[y])
                        articleUser.minute = abs(currentComponents.minute! - x.minute[y])
                    }
                    articles.append(articleUser)
                }
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
        
        resultVC?.platei = article.plateNumber
        resultVC?.imageData.sd_setImage(with: url)
        resultVC?.emailText = article.emailText
        resultVC?.foodName = "Yemek ismi : \(article.nameFood)"
        resultVC?.dateText = "Kalan saat : \(article.hour) ve Dakika : \(article.minute)"
        resultVC?.plateCount = String(article.plateCount)
        resultVC?.plateNumber = article.plateNumber
        articles.removeAll()
        userArray.removeAll()
        self.navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    
}
