//
//  ContactsHelper.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/9/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import Foundation
import Contacts

struct ContactsHelper {

    
    func addContactsToList(array: [Any], complitedHandle: (()->())) {
        
        
        // Saving the newly created contact
        
        let saveRequest = CNSaveRequest()
        
        let queue = DispatchQueue(label: "your.queue.SuperCheckSystem")
        var count: Int = 0
        count = array.count
        let backQueue = OperationQueue()
        backQueue.maxConcurrentOperationCount = 10
        
        for dict in array {
            
            backQueue.addOperation {
                
                let profile = dict as! [String:Any]
                let contact = CNMutableContact()
                if let phone = profile["mobile_phone"] as? String {
                    
                    let letters = NSCharacterSet.letters
                    let range = phone.rangeOfCharacter(from: letters)
                    if (phone.count == 0 || phone.contains("*.") || range != nil) {
                        queue.sync {
                            count -= 1
                        }
                        return
                    }
                    if (self.checkExistenceInContacts(phone: phone)) {
                        queue.sync {
                            count -= 1
                        }
                        return
                    }
                    contact.phoneNumbers = [CNLabeledValue(
                        label:CNLabelPhoneNumberMobile,
                        value:CNPhoneNumber(stringValue:phone))]
                } else {
                    queue.sync {
                        count -= 1
                    }
                    return
                }
                
                if let urlString = profile["photo_50"] as? String {
                    
                    if (urlString.count != 0) {
                        let url = URL(string: urlString)
                        do {
                            contact.imageData = try Data(contentsOf: url!)
                        } catch {
                            print("error fetch image")
                        }
                    }
                }
                
                if let name = profile["first_name"] as? String, let familyName = profile["last_name"] as? String {
                    if (name.count != 0 && familyName.count != 0) {
                        contact.givenName = name
                        contact.familyName = familyName
                    } else {
                        queue.sync {
                            count -= 1
                        }
                        return
                    }
                }
                
                let homeAddress = CNMutablePostalAddress()
                if let cityDict = profile["city"] as? [String:Any] {
                    homeAddress.city = cityDict["title"] as! String
                    contact.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
                }
                
                if let birthdayDate = profile["bdate"] as? String {
                    var birthday = DateComponents()
                    let fullNameArr = birthdayDate.components(separatedBy: ".")
                    if birthdayDate.count > 5 {
                        birthday.day = Int(fullNameArr[0]) ?? 0
                        birthday.month = Int(fullNameArr[1]) ?? 0
                        birthday.year = Int(fullNameArr[2]) ?? 0
                        contact.birthday = birthday
                    } else {
                        birthday.day = Int(fullNameArr[0]) ?? 0
                        birthday.month = Int(fullNameArr[1]) ?? 0
                        birthday.year = 2000
                        contact.birthday = birthday
                    }
                }
                
                saveRequest.add(contact, toContainerWithIdentifier:nil)
                queue.sync {
                    count -= 1
                }
            }
        }
        
        var num: Int = array.count
        repeat {
            Thread.sleep(forTimeInterval: 2)
            queue.sync {
                num = count
            }
        } while (num != 0)
        
        let store = CNContactStore()
        do {
            try store.execute(saveRequest)
        } catch {
            print(error)
        }
        
        complitedHandle()
    }
    
    func checkExistenceInContacts(phone: String) -> Bool {
        // Checking if phone number is available for the given contact.
        
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: phone)
        let keysToFetch = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let store = CNContactStore()
        do {
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch)
            if contacts.count > 0 {
                return true
            }
        } catch {
            print(error)
            return true
        }
        return false
    }
}


