//
//  PostCell.swift
//  SciSocial
//
//  Created by Erblin Berisha on 7/26/17.
//  Copyright © 2017 Erblin Berisha. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

}
