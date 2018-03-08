//
//  ViewController.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 2/28/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import Contacts

class TabBarSocialController: UITabBarController {
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Choose your Social"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

