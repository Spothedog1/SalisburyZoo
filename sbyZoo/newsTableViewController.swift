//
//  newsTableViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/5/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class newsTableViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var news:[news]?
    let firebase: firebaseAPI = firebaseAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleLabel.text = "News"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Twiddlestix", size: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
        self.tableView.rowHeight = (UIScreen.main.bounds.width/5)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bamboo"))
        
        self.news = (appDelegate?.news)!
        let queue = DispatchQueue(label: "imageDownload", qos: DispatchQoS.userInitiated)
        queue.async {
            for news in self.news! {
                if (news.image == nil){
                    if let imageURL = news.imageReference {
                        self.firebase.downloadImage(imageURL, completionHandler: { (error, image) -> Void in
                            if (error){
                                print("Image Downloading Error")
                            } else {
                                if let newsImage = image {
                                    print("Downloading Image: \(news.title)")
                                    news.image = newsImage
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewsSegue", sender: (indexPath as NSIndexPath).row)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let uNews = self.news {
            return uNews.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customNewsCell", for: indexPath) as! customNewsCell
        let newsObj = self.news![indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        cell.customizeCell(label: newsObj.title)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        if segue.identifier == "NewsSegue" {
            if let row = sender {
                let index = row as! Int
                let newsArticle = self.news?[index]
                let newsViewController = segue.destination as! newsInformationViewContoller
                newsViewController.article = newsArticle
                
            }
        }

        
        
    }

}
