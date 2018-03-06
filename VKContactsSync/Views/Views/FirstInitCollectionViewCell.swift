//
//  FirstInitCollectionViewCell.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/2/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import expanding_collection
import RxSwift

class FirstInitCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var loginButton: UIButton!
    var bag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
