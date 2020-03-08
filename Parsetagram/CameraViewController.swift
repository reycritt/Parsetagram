//
//  CameraViewController.swift
//  Parsetagram
//
//  Created by cory on 2/29/20.
//  Copyright © 2020 royalty. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let post = PFObject(className: "Posts")//Creates a dictionary in Heroku named "Posts", and it stores custom dictionary keys and their associated values
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!//"PFUser.current()" for whoever is "logged in" in Parse
        let imageData = imageView.image!.pngData()//Uses the scaled image selected from camera/photo library
        let file = PFFileObject(name: "image.png", data: imageData!)//Converts the image into binary that Heroku can save in the database
        post["image"] = file
        
        post.saveInBackground { (success, error) in//Creates a schema, a list of labelled columns, and will save it to some row in Parse
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved")
            } else {
                print("\(error)")
            }
        }
    }
    
    @IBAction func onImageSelect(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self//Tell the controlled what was taken (ie an image)
        picker.allowsEditing = true//Allows enditing of the image
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {//If the camera is available/usable, do this (in this case, use the camera)
            picker.sourceType = .camera//Automatically will select the camera or library; if camera unavailable, use library; this can also be set to a tab bar?
        } else {
            picker.sourceType = .photoLibrary
            
        }
        picker.modalPresentationStyle = .fullScreen//Gets rid of stupid, idiotic, awful default automatic presentation "pull-down"
        present(picker, animated: true, completion: nil)//Shows/displays the picker/sourceType
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {//Gives a dictionary "info" containing the image
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        //let scaledImage = image.af_imageScaled(to: size)//Scales the image using AlamofireImage pod using "size"
        let scaledImage = image.af_imageAspectScaled(toFill: size)//Crops a nicer image
        imageView.image = scaledImage//Sets image
        dismiss(animated: true, completion: nil)//Dismisses the camera view
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
