//
//  VKontakteSynchronizer.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit

struct VKontakteSynchronizer {
    
    func loadProfileWithAccessToken(accessToken: String, userID: String, completionHandler: @escaping (Any) -> Void) {
        
        let webClient = WebClient()
        let getProfileUrl = "\(Constants.VKONTAKTE_URL)/method/\(Constants.VKONTAKTE_GET_PROFILE_METHOD)?PARAMETERS&access_token=\(accessToken)&fields=city,domain,contacts&v=5.73"
        
        webClient.getRequestWithUrl(url: getProfileUrl, completionHandler: { (response) in
            
            let dictProfile = response.value as? [String: AnyObject]
            
            var clientInfo = [String:Any]()
            clientInfo["userAccessToken"] = accessToken
            clientInfo["typeOfRequest"] = Constants.TYPE_VKONTAKTE
            clientInfo["userID"] = userID
            clientInfo["name"] = userID
            clientInfo["userName"] = dictProfile!["response"]?["first_name"]!
            clientInfo["userLastName"] = dictProfile!["response"]?["last_name"]!
            clientInfo["phone"] = dictProfile!["response"]?["phone"]!
            
            // date
            let formater = DateFormatter()
            formater.timeZone = TimeZone(secondsFromGMT: 0)
            formater.dateFormat = "dd.MM.yyyy"
            clientInfo["dateOfBirth"] = formater.date(from: dictProfile!["response"]?["bdate"]! as! String)
            
            let coreDataManager = CoreDataManager()
            coreDataManager.addClientInfoEntity(clientInfoPassed: clientInfo)
            coreDataManager.save()
            
            completionHandler(response)
        })
    }
    
    func loadFriendsWithAccessToken(accessToken: String, completionHandlerFirst: @escaping (Any) -> Void) {
        
        let webClient = WebClient()
        let getProfileUrl = "\(Constants.VKONTAKTE_URL)/method/\(Constants.VKONTAKTE_GET_FRIENDS_INFO_METHOD)?PARAMETERS&access_token=\(accessToken)&fields=city,domain,contacts,bdate,photo_50&v=5.73"
        
        webClient.getRequestWithUrl(url: getProfileUrl, completionHandler: { (response) in
            
            
            if let value = response.value as? [String:Any] {
                if let error = value["error"] as? [String:Any] {
                    if let errorCode = error["error_code"] as? Int {
                        if (errorCode == 5) {
                            let coredataman = CoreDataManager()
                            coredataman.removeElement(type: Constants.TYPE_VKONTAKTE)
                        }
                    } else {
                        print(error)
                    }
                }
                if (value["response"] as? [String:Any]) != nil {
                    
                    if let resultDictResponse: Dictionary<String,Any> = value["response"] as? Dictionary<String, Any> {
                        let items = resultDictResponse["items"] ?? []
                        completionHandlerFirst(items)
                        return;
                    }
                }
                completionHandlerFirst([])
            } else {
                completionHandlerFirst([])
            }
        })
    }
    
    func getAccessTokenForVk() -> String {
        let coreDataManager = CoreDataManager()
        let objectVK = coreDataManager.getClientInfoObjectFor(type: Constants.TYPE_VKONTAKTE)
        if let currentUser = objectVK {
            let result = currentUser["userAccessToken"] as! String
            return result
        } else {
            return ""
        }
    }
    
    func removeVkFromCoreData() {
        let coreDataManager = CoreDataManager()
        coreDataManager.removeElement(type: Constants.TYPE_VKONTAKTE)
    }
}
