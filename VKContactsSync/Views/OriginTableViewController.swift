//
//  OriginTableViewController.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/1/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import expanding_collection

class OriginTableViewController: ExpandingTableViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        headerHeight = 236
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        headerHeight = 236
    }
}
