//
//  FriendListViewConroller.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SDWebImage
import RxSwift
import NVActivityIndicatorView
import EventKit

class FriendListViewConroller: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var firendListTableView: UITableView!
    let vkModel = VKViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize tableView
        self.hidesBottomBarWhenPushed = false
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        self.activityIndicatorView.color = UIColor.orange
        
        firendListTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            
            self?.activityIndicatorView.startAnimating()
            self?.reloadSelf(compliteHeader: {
                self?.firendListTableView.dg_stopLoading()
            })
            
            }, loadingView: loadingView)
        firendListTableView.dg_setPullToRefreshFillColor(UIColor.flatOrangeColorDark())
        firendListTableView.dg_setPullToRefreshBackgroundColor(firendListTableView.backgroundColor!)
        
        // set navigations
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Friends"
        // Do any additional setup after loading the view.
        
        // set sync button
        let image = UIImage(named: "connected")?.withRenderingMode(.automatic)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(synchronizationMethod))
        button.tintColor = .white
        self.navigationItem.rightBarButtonItem = button
        
        activityIndicatorView.startAnimating()
        self.reloadSelf {
        }
        
//        let calendar = EKEventStore().defaultCalendarForNewReminders()
//        RemindersHelper().removeListWithCalendar(calendar: calendar!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadSelf(compliteHeader:@escaping ()->()) {
        
        vkModel.getUsers(complitedHandler: { [weak self] (array) in
            let result = array
            self?.vkModel.arrayOfUsers = result.first as! [Any]
            DispatchQueue.main.async {
                self?.firendListTableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
                compliteHeader()
            }
        })
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
        return vkModel.arrayOfUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellVkUserIdentifier) as! VkontakteUserTableViewCell
        let user = self.vkModel.arrayOfUsers[indexPath.row] as! [String:Any]
        cell.fillCellWithUser(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension FriendListViewConroller: SyncDelegate {
    
    @objc func synchronizationMethod() {
        performSegue(withIdentifier: Constants.segueSynchronizationListSegueueIdentofier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let syncController = segue.destination as! SynchronizationViewController
        syncController.delegate = self
    }
    
    func syncContacts() {
        
        let helper = ContactsHelper()
        let queue = OperationQueue()
        queue.addOperation {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            helper.addContactsToList(array: (self.vkModel.arrayOfUsers), complitedHandle: {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicatorView.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            })
        }
    }
    func syncReminders() {
        let helper = RemindersHelper()
        let queue = OperationQueue()
        queue.addOperation { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
            helper.addRemindersToList(array: (self?.vkModel.arrayOfUsers)!, complitedHandle: {
                DispatchQueue.main.async {
                    self?.activityIndicatorView.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            })
        }
    }
}
