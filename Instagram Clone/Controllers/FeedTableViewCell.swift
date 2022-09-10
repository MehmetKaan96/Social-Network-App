//
//  FeedTableViewCell.swift
//  Instagram Clone
//
//  Created by mehmet on 5.09.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var docIDLabel: UILabel!
    @IBOutlet var addLikeButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var likeInfoLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addLikeButtonTapped(_ sender: Any) {
        let firebaseDB = Firestore.firestore()
        
        if let likeCount = Int(likeInfoLabel.text!) {
            
            let likeNumber = ["likes" : likeCount + 1] as [String : Any]
            
            firebaseDB.collection("Posts").document(docIDLabel.text!).setData(likeNumber, merge: true)
        }
 
    }
}
