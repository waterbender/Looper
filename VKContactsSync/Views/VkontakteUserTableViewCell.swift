//
//  VkontakteUserTableViewCell.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/8/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit

class VkontakteUserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutIfNeeded() {
        
        super.layoutIfNeeded()
        userIconImageView.layer.cornerRadius = self.userIconImageView.bounds.height/2
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.masksToBounds = true
    }
}
