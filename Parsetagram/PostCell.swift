//
//  PostCell.swift
//  Parsetagram
//
//  Created by cory on 2/29/20.
//  Copyright © 2020 royalty. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
