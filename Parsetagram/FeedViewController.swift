//
//  FeedViewController.swift
//  Parsetagram
//
//  Created by cory on 2/29/20.
//  Copyright © 2020 royalty. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject]()//Contains all values in Heroku
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")//Grabs the dictionary "Posts"
        query.includeKeys(["author", "caption"])//Grabs the "author" values
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count//Table view has the amount of posts as the amount of cells displayed
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//Defines what is visible in the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell//Cell is recyclable
        
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        
        cell.userLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.imageView?.af_setImage(withURL: url)
        
        
        return cell
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
