//
//  UploadViewController.swift
//  Instagram Clone
//
//  Created by mehmet on 3.09.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController  {

    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var descriptionLabel: UITextField!
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let imageViewGesture = UITapGestureRecognizer(target: self, action: #selector(addImage))
        imageView.addGestureRecognizer(imageViewGesture)
        
    }
    
    func makeAlert(errorTitle: String, errorMessage: String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            //each image will have a uuid name
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(errorTitle: "Error!", errorMessage: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //DataBase
                            
                            let fireStoreDataBase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference?
                            
                            let post = ["imageUrl" : imageUrl!,
                                        "postedBy": Auth.auth().currentUser!.email!,
                                        "description" : self.descriptionLabel.text!,
                                        "postTime" : FieldValue.serverTimestamp(),
                                        "likes" : 0
                                        ] as [String : Any]
                            
                            firestoreReference = fireStoreDataBase.collection("Posts").addDocument(data: post, completion: { error in
                                if error != nil {
                                    self.makeAlert(errorTitle: "Error", errorMessage: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.descriptionLabel.text = ""
                                    
                                    //Takes you to the feed page
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
}

extension UploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //describe what will happen after picking images
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image  = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
}
