//
//  ViewController.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 2/28/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import expanding_collection
import Contacts
import RxSwift
import RxCocoa
import VK_ios_sdk

class ViewController: ExpandingViewController {

    var items: NSArray = [Constants.TYPE_VKONTAKTE, Constants.TYPE_FACEBOOK]
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        
        itemSize = CGSize(width: view.frame.width, height: view.frame.height-70) //IMPORTANT!!! Height of open state cell
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Helpers

extension ViewController {
    
    fileprivate func registerCell() {
        
        
        let nibName = UINib(nibName: String(describing: FirstInitCollectionViewCell.self), bundle:nil)
        self.collectionView?.register(nibName, forCellWithReuseIdentifier: "FirstInitCollectionViewCellIdentifier")
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        
        let toViewController: OriginTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "OriginTableViewControllerIdentifier") as! OriginTableViewController
        return toViewController
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}

extension ViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FirstInitCollectionViewCellIdentifier", for: indexPath) as! FirstInitCollectionViewCell
        
        cell.loginButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                // code that has to be handled by view controller
                print(Thread.current)
                
                self?.performSegue(withIdentifier: Constants.segueLoginIdentifier, sender: cell)
            }).disposed(by: cell.bag)

        
        return cell
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let launch = LauncherModel()
        let type = launch.getTypeWithSegueue(segueueType: segue.identifier!)
        let destanLogin = segue.destination as! LoginWithSiteViewContoller
        destanLogin.url = launch.getLoginUrl(type: type)
    }
}
