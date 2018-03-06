//
//  LauncherModel.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import Foundation

struct LauncherModel {
    
    func getLoginUrl(type: (String)) -> URL {
        
        var url: String;
        if (type==Constants.TYPE_VKONTAKTE) {
           url = "\(Constants.VKONTAKTE_LOGIN_URL)?client_id=\(Constants.VKClientID)&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.52"
        } else {
            url = "www.google.com"
        }
        
        let urlClass = URL(string: url)
        return urlClass!
    }
    
    func getTypeWithSegueue(segueueType: String) -> String {
        if segueueType==Constants.segueLoginIdentifier {
            return Constants.TYPE_VKONTAKTE
        } else {
            return Constants.TYPE_FACEBOOK
        }
    }
    
    func recordIfNeedded(url: String, compileHendler: @escaping ()->()) {
        
            if url.range(of:"access_token") != nil {
                
                let info = url.components(separatedBy: "#").last
                let access_components = info?.components(separatedBy: "=")[1]
                let userId = info?.components(separatedBy: "=")[3]
                let access_token = access_components?.components(separatedBy: "&").first
                
                let vkSync = VKontakteSynchronizer()
                vkSync.loadProfileWithAccessToken(accessToken: access_token!, userID: userId!, completionHandler: { (profile) in
                  
                    DispatchQueue.main.async {
                        compileHendler()
                    }
                })
                
                
            }
    }
}
