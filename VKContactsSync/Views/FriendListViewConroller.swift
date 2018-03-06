//
//  FriendListViewConroller.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class FriendListViewConroller: UIViewController {

    @IBOutlet weak var firendListTableView: UITableView!
    var arrayOfUsers = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        firendListTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            self?.firendListTableView.dg_stopLoading()
            }, loadingView: loadingView)
        firendListTableView.dg_setPullToRefreshFillColor(UIColor.flatOrangeColorDark())
        firendListTableView.dg_setPullToRefreshBackgroundColor(firendListTableView.backgroundColor!)
        
        // set navigations
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Friends"
        // Do any additional setup after loading the view.
        
        let vkModel = VKViewModel()
        arrayOfUsers = vkModel.getUsers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FriendListViewConroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let fireindIdentifier = "FriendReusableCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: fireindIdentifier)!
        
        return cell
    }
}
