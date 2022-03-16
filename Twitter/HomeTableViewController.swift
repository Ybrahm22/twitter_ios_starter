//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by yug brahmbhatt on 3/11/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    // var - a variable that can be changed
    // let - a variable that is cannot be changed
    
    // create dictionary and int variable
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!

    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
        
    @objc func loadTweets(){
        
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()

            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // anytime we call the api, repopulate the data from the api
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
            
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!!")
            print(Error.localizedDescription)

        })
    }
    
    
    
    
    
    func LoadMoreTweets(){
        
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()

            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            // anytime we call the api, repopulate the data from the api
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
            
            
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! oh no!!")
            print(Error.localizedDescription)

        })
    }
    
    // when the user get to the end of the page run loadmoretweets (getting more tweets)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == tweetArray.count {
            LoadMoreTweets()
        }
        
    }

    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        cell.datePostedLabel.text = getRelativeTime(timeString: (tweetArray[indexPath.row]["created_at"] as? String)!)
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data:imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)

        return cell
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    func getRelativeTime(timeString: String) -> String{
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        time = dateFormatter.date(from: timeString)!
        return time.timeAgoDisplay()
    }
}
        
extension Date {
            func timeAgoDisplay() -> String {
                let secondsAgo = Int(Date().timeIntervalSince(self))
                let minute = 60
                let hour = 60 * minute
                let day = 24 * hour
                let week = 7 * day
                if secondsAgo < minute {
                    return String(secondsAgo) + " seconds ago"
                } else if secondsAgo > minute && secondsAgo/minute < 60 {
                    return String(secondsAgo/minute) + " minutes ago"
                } else if secondsAgo/minute >= 60 && secondsAgo/hour < 24 {
                    return String(secondsAgo/hour) + " hours ago"
                } else if secondsAgo/hour >= 24 && secondsAgo/day < 7 {
                    return String(secondsAgo/day) + " days ago"
                } else {
                    return String(secondsAgo/week) + " weeks ago"
                }
            }
        }


