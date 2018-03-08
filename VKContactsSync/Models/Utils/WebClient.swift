//
//  WebClient.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/5/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import Foundation
import Alamofire

struct WebClient {
    public func getRequestWithUrl(url: String, completionHandler: @escaping (DataResponse<Any>) -> Void) {
        
        Alamofire.request(url).responseJSON { (response) in
            
//            if let value = response.value as? [String: AnyObject] {
//                print(value)
//            }
            
            completionHandler(response)
        }
    }
    
    public func postRequestWithUrl(url: String, and postData: Parameters, completionHandler: @escaping (Any) -> Void) -> Void {
        
        Alamofire.request(url, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: nil).responseJSON { (dataResponse) in
            completionHandler(dataResponse)
        }
    }
}

