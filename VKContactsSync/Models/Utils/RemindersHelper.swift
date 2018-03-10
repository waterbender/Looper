//
//  RemindersHelper.swift
//  VKContactsSync
//
//  Created by Yevgenii Pasko on 3/9/18.
//  Copyright © 2018 Yevgenii Pasko. All rights reserved.
//

import UIKit
import EventKit

struct RemindersHelper {
    func addRemindersToList(array: [Any], complitedHandle: @escaping (()->())) {
        // Saving the newly created contact
        
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                
                if !granted {
                    print("Access to store not granted")
                    complitedHandle()
                } else {
                    
                    let calendar:EKCalendar
                    let calendarTitle = "Birthdays"
                    let calendars = eventStore.calendars(for: .reminder)
                    let filtered = calendars.filter { $0.title ==  calendarTitle}
                    if (filtered.count > 0) {
                        calendar = filtered.first!
                        self.removeListWithCalendar(calendar: calendar)
                    } else {
                        
                        calendar = EKCalendar(for: .reminder, eventStore: eventStore)
                        let calendar = EKCalendar(for: .reminder, eventStore: eventStore)
                        calendar.title = "Birthdays"
                        
                        var localSource: EKSource?
                        for source in eventStore.sources {
                            if (source.sourceType == .calDAV && source.title=="iCloud") {
                                localSource = source;
                            }
                        }
                        if (localSource == nil)
                        {
                            for source in eventStore.sources
                            {
                                if (source.sourceType == .local)
                                {
                                    localSource = source;
                                    break;
                                }
                            }
                        }
                        calendar.source = localSource
                        
                        do {
                            try eventStore.saveCalendar(calendar, commit: true)
                        } catch let error {
                            print("Reminder failed with error \(error.localizedDescription)")
                        }
                    }
                    
                    for dict in array {
                        
                        let reminder = EKReminder(eventStore: eventStore)
                        let profile = dict as! [String:Any]
                        reminder.calendar = calendar
                        reminder.title = "Birthdays"
                        
                        // set title
                        if let name = profile["first_name"] as? String, let familyName = profile["last_name"] as? String {
                            if (name.count != 0 && familyName.count != 0) {
                                reminder.title = "Birthday \(name) \(familyName). Attantion!!!"
                            }
                        }
                        
                        if let birthdayDate = profile["bdate"] as? String {
                            var start = DateComponents()
                            start.timeZone = NSTimeZone.default
                            let fullNameArr = birthdayDate.components(separatedBy: ".")
                            if birthdayDate.count > 5 {
                                start.day = Int(fullNameArr[0]) ?? 0
                                start.month = Int(fullNameArr[1]) ?? 0
                                start.year = Int(fullNameArr[2]) ?? 0
                            } else {
                                start.day = Int(fullNameArr[0]) ?? 0
                                start.month = Int(fullNameArr[1]) ?? 0
                                start.year = 2000
                            }
                            print(birthdayDate)
                            
                            let userCalendar = Calendar.current // user calendar
                            let someDateTime = userCalendar.date(from: start)
                            let alarm = EKAlarm(absoluteDate: someDateTime!)
                            reminder.alarms = [alarm]
                            reminder.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)]
                            var endComp = start
                            endComp.year = start.year! + 100
                            reminder.dueDateComponents = endComp
                            reminder.startDateComponents = start
                            //reminder.completionDate = start.date
                        }
                        
                        do {
                            try eventStore.save(reminder,
                                                commit: true)
                        } catch let error {
                            print("Reminder failed with error \(error.localizedDescription)")
                        }
                    }
                    complitedHandle()
                }
        })
    }
    
    
    
    func removeListWithCalendar(calendar: EKCalendar) {
        let eventStore = EKEventStore()
        let predicate = eventStore.predicateForReminders(in: [calendar])
        eventStore.fetchReminders(matching: predicate) { (reminders) in
            for reminder in reminders! {
                do {
                    try eventStore.remove(reminder, commit: true)
                } catch {
                    print(error)
                }
            }
        }
        
    }
}
