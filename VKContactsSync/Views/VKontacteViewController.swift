//
//  VKontacteViewController.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/8/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VKontacteViewController: UIViewController {

    @IBOutlet weak var vkontakteButton: UIButton!
    let disposeBug = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vkontakteButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                
                let model = LauncherModel()
                let identifier = model.getSegueueIdentifier(withType: Constants.TYPE_VKONTAKTE)
                self?.performSegue(withIdentifier: identifier, sender: self)
                
            }).disposed(by: disposeBug)
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

extension VKontacteViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.destination is LoginWithSiteViewContoller) {
            let launch = LauncherModel()
            let type = launch.getTypeWithSegueue(segueueType: segue.identifier!)
            let destanLogin = segue.destination as! LoginWithSiteViewContoller
            destanLogin.url = launch.getLoginUrl(type: type)
        }
    }
}
