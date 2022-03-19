//
//  ProfileViewController.swift
//  Twitter
//
//  Created by yug brahmbhatt on 3/18/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        getUser()
    }
    
    func getUser() {
        let requestUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        
        TwitterAPICaller.client?.getDictionaryRequest(url: requestUrl, parameters: [:] as [String : Any], success: { (userInfo: (NSDictionary)) in
            
            let imageUrl = URL(string: (userInfo["profile_image_url_https"] as? String)!)
            let data = try? Data(contentsOf: imageUrl!)
            
            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
            
            self.nameLabel.text = userInfo["name"] as? String
            
            if let screenName = userInfo["screen_name"] as? String {
                self.handleLabel.text = "@" + screenName
            }
            
            self.descriptionLabel.text = userInfo["description"] as? String
            
            if let tweets = userInfo["statuses_count"] as? Int {
                self.tweetsLabel.text = String(tweets)
            }
            
            if let following = userInfo["friends_count"] as? Int {
                self.followingLabel.text = String(following)
            }
            
            if let followers = userInfo["followers_count"] as? Int {
                self.followersLabel.text = String(followers)
            }
            
        }, failure: { (Error) in
            print("Error: could not retrieve user info.")
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
