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
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject]()//Contains all values in Heroku
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment here"//Labels parts of the input bar
        commentBar.sendButton.title = "Post!"
        commentBar.delegate = self//When ever bar is "sent"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)//Observers the selector, and will make a responder
    }
    
    @objc func keyboardWillBeHidden (note: Notification) {
        commentBar.inputTextView.text = nil//Empties comment bar if there is anything inside
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar//Disables comment bar by default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")//Grabs the dictionary "Posts"
        query.includeKeys(["author", "comments", "comments.author"])//Grabs the "author" values; "comments.author" will grab the author associated to the comment
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create comment
        let comment = PFObject(className: "Comments")
        
        comment["text"] = text
        comment["post"] = selectedPost//A row of comment named "post"
        comment["author"] = PFUser.current()//Current user???
        selectedPost.add(comment, forKey: "comments")//Every post should have something called "comments" where it posts a comment; adds "comments" to "Posts" in database
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment saved!")
            } else {
                print("Failed to save comment")
            }
        }
        
        tableView.reloadData()
        
        //Clear/dimiss comment bar
        commentBar.inputTextView.text = nil//Empties comment bar if there is anything inside
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []//"??" if the left side is nil, make it the right as default
        //        return posts.count//Table view has the amount of posts as the amount of cells displayed
        return comments.count + 2//+2 for that post and the comment cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//Defines what is visible in the cell
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell//Cell is recyclable
            
            
            
            let user = post["author"] as! PFUser
            
            cell.userLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.imageView?.af_setImage(withURL: url)
            
            
            return cell
        } else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()//Cleans cache and logs out
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        /*
         This connected code belongs in the scene delgate, as reference by the discussion board "Staying logged in Across restarts, does not stay logged in, also cannot log out"
         */
        let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate//Takes the class delegate and casts it to SceneDelegate file to use the "window" property
        sceneDelegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        //let comment = PFObject(className: "comments")
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {//row might be section???
            //print("Text that says it printed")
            showsCommentBar = true//Shows comment bar
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post//Saves what post was tapped to add comment
        }
        
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
/*
 For cell selection, can deselect "Selection" in the table view cell ID card area in storyboard
 */
