//
//  UserInfo.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import CoreData

class UserDataObject: NSManagedObject {
    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var userName: String?
    @NSManaged public var userPhoto: NSData?
    @NSManaged public var userId: ClientInfoObject?
}
