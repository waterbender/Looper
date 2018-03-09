//
//  Constants.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: List of Constants
    
    static let TYPE_VKONTAKTE = "VKontakte"
    static let TYPE_FACEBOOK = "Facebook"
    
    static let VKONTAKTE_LOGIN_URL = "https://oauth.vk.com/authorize"
    static let VKONTAKTE_URL = "https://api.vk.com/"
    static let VKONTAKTE_GET_PROFILE_METHOD = "account.getProfileInfo"
    static let VKONTAKTE_GET_FRIENDS_INFO_METHOD = "friends.get"
    
    // segueues type
    // ViewController
    static let segueLoginIdentifier = "AuthorizationVkSegue"
    static let segueFriendsListIdentifier = "FriendsListSegueue"
    static let segueSynchronizationListSegueueIdentofier = "SynchronizationListSegueue"
    
    // VK Settings
    static let VKClientID = "6390042"
    
    // Cells identifiers
    static let cellVkUserIdentifier = "VkontakteUserTableViewCellIdentifier"
    
}
