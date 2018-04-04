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
   
    func fillCellWithUser(user: [String:Any]) {
        
        self.nameLabel.text = ("\(user["first_name"]!) \(user["last_name"]!)")
        let phone = user["mobile_phone"] ?? ""
        self.numLabel.text = ("\(phone)")
        self.userIconImageView.image = nil
        self.userIconImageView.sd_setImage(with: URL(string: (user["photo_50"] as! String)), placeholderImage: UIImage())
        
        if let dictLocation = user["city"] as? [String:Any] {
            self.addressLabel.text = (dictLocation["title"] ?? "") as? String
        } else {
            self.addressLabel.text = ""
        }
        
    }
    
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
