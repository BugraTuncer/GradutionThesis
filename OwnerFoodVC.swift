//
//  OwnerFoodVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 5.04.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class OwnerFoodVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var db : Firestore!
    override func viewDidLoad() {
        imageView.isHidden = true
        db = Firestore.firestore()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked(_:)))
        imageView.addGestureRecognizer(imageTapRecognizer)
        super.viewDidLoad()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func stepperClicked(_ sender: Any) {
        
        plateLabel.text = "Tabak sayısı :\(Int(stepper.value))"
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        selectImage()
    }
    @IBAction func saveClicked(_ sender: Any) {
        let date = NSDate()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.hour,.minute], from: date as Date)
        
        let storage=Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("Media")
        if  imageView.image != nil && self.nameText.text != "" {
            if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
                let uuid=UUID().uuidString
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("Error put data")
                    } else {
                        imageReference.downloadURL { (url, error) in
                            let imageURL = url?.absoluteString
                            
                            self.db.collection("Owner").document((Auth.auth().currentUser?.email)!).collection("Food").document("\(self.nameText.text!)").setData([
                                "Platecount" : Int(self.stepper.value),
                                "imageURL" : imageURL!,
                                "nameFood"  : self.nameText.text!,
                                "Day" : components.day,
                                "Hour" : components.hour,
                                "Minute" : components.minute
                                ])
                            { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                            self.performSegue(withIdentifier: "toMenu", sender: nil)
                            
                        }
                    }
                }
            }
        }else {
            self.makeAlert()
        }
    }
    @objc func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Resim Secme", message:"Tıkla", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.addButton.isHidden = true
                self.imageView.isHidden = false
                imagePickerController.sourceType = .camera
                self.present(imagePickerController,animated: true,completion: nil)
            } else {
                print("Camera available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Galeri", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.addButton.isHidden = true
            self.imageView.isHidden = false
            self.present(imagePickerController,animated: true,completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .default, handler: {
            
            (UIAlertAction) in
        }))
        
        self.present(actionSheet,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func makeAlert() {
        let alert = UIAlertController(title: "Boş Bırakmayınız", message:"Gerekli yerleri lutfen doldurunuz" , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
