//
//  SynchronizationViewController.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/8/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import RxSwift

protocol SyncDelegate {
    func syncContacts()
    func syncReminders()
}

class SynchronizationViewController: UIViewController {

    @IBOutlet weak var synchronizeContactsButton: UIButton!
    @IBOutlet weak var addBirthdaysButton: UIButton!
    @IBOutlet weak var backStageView: UIView!
    var delegate: SyncDelegate?
    let disposeBug = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.synchronizeContactsButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.syncContacts()
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBug)
        self.addBirthdaysButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.syncReminders()
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBug)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backStageView.layer.cornerRadius = backStageView.bounds.width/8
        backStageView.layer.borderWidth = 3
        backStageView.layer.borderColor = UIColor.orange.cgColor
        
        synchronizeContactsButton.layer.cornerRadius = synchronizeContactsButton.bounds.height/2
        addBirthdaysButton.layer.cornerRadius = addBirthdaysButton.bounds.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
