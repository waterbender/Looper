//
//  ClientInfoDataObject.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/6/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import CoreData

class ClientInfoObject: NSManagedObject {
    @NSManaged public var typeOfRequest: String?
    @NSManaged public var userAccessToken: String?
    @NSManaged public var userId: String?
    @NSManaged public var dateOfBirth: NSDate?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var userName: String?
    @NSManaged public var userLastName: String?
}


