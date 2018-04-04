//
//  VKViewModel.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit

class VKViewModel {

    var arrayOfUsers = [Any]()
    
    func getUsers(complitedHandler: @escaping ([Any])->()) {
        let synchronizer = VKontakteSynchronizer()
        let accessToken = synchronizer.getAccessTokenForVk()
        synchronizer.loadFriendsWithAccessToken(accessToken: accessToken) { (response) in
            complitedHandler([response])
        }
    }

}
