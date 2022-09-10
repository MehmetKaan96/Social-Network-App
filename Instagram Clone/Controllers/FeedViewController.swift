//
//  FeedViewController.swift
//  Instagram Clone
//
//  Created by mehmet on 3.09.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage

class FeedViewController: UIViewController {
    
    var emailArray = [String]()
    var descriptionArray = [String]()
    var likeArray = [Int]()
    var imageArray = [String]()
    var documentIDArray = [String]()
    
    @IBOutlet var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        feedTableView.delegate = self
        feedTableView.dataSource = self
        // Do any additional setup after loading the view.
        getDataFromFireStore()
    }
    
}


extension FeedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.descriptionLabel.text = descriptionArray[indexPath.row]
        cell.likeInfoLabel.text = String(likeArray[indexPath.row])
        cell.postImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.usernameLabel.text = emailArray[indexPath.row]
        cell.profileImageView.image = UIImage(named: "select.png")
        cell.docIDLabel.text = documentIDArray[indexPath.row]
        
        return cell
    }
    
    
    func getDataFromFireStore() {
        let fireStoreDB = Firestore.firestore()
        
        fireStoreDB.collection("Posts").order(by: "postTime", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.descriptionArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    for documents in snapshot!.documents {
                        let docID = documents.documentID
                        self.documentIDArray.append(docID)
                        if let postedBy = documents.get("postedBy") as? String {
                            self.emailArray.append(postedBy)
                        }
                        
                        if let desc = documents.get("description") as? String {
                            self.descriptionArray.append(desc)
                        }
                        
                        if let postImage = documents.get("imageUrl") as? String {
                            self.imageArray.append(postImage)
                        }
                        
                        if let likes = documents.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                    }
                    self.feedTableView.reloadData()
                }
            }
            
        }
    }
    
}
