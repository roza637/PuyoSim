//
//  LocalNotificationModel.swift
//  PuyoSim
//
//  Created by roza on 2017/08/03.
//  Copyright © 2017年 GMO Click Holdings Co,. Ltd. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationModel {
    
    static var instance: LocalNotificationModel_Interface {
        if #available(iOS 10.0, *) {
            return LocalNotificationModel.Implement_iOS10()
        } else {
            return LocalNotificationModel.Implement_iOS9()
        }
    }

    private init() { }
    
    class Implement_iOS9: LocalNotificationModel_Interface {
        func scheduleNotification(_ notification: LocalNotification) {
            UIApplication.shared.scheduleLocalNotification(notification.uiLocalNotification)
        }
        
        func cancelNotification(identifier: String){
            UIApplication.shared.scheduledLocalNotifications?.filter{ $0.identifier == identifier }.forEach{ UIApplication.shared.cancelLocalNotification($0) }
        }
        
        func cancelAllNotifications() {
            UIApplication.shared.scheduledLocalNotifications?.forEach{ UIApplication.shared.cancelLocalNotification($0) }
        }
        
        var notifications: [LocalNotification] {
            return UIApplication.shared.scheduledLocalNotifications?.map{ $0.localNotification } ?? []
        }
    }
    
    @available(iOS 10.0, *)
    class Implement_iOS10: LocalNotificationModel_Interface {
        func scheduleNotification(_ notification: LocalNotification) {
            UNUserNotificationCenter.current().add(notification.notificationrequest, withCompletionHandler: nil)
        }

        func cancelNotification(identifier: String) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        
        func cancelAllNotifications() {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }

        var notifications: [LocalNotification] {
            let semaphore = DispatchSemaphore(value: 0)
            var notifications: [LocalNotification]?
            UNUserNotificationCenter.current().getPendingNotificationRequests{ requests in
                notifications = requests.map{ LocalNotification(request: $0) }
                semaphore.signal()
            }
            semaphore.wait()
            return notifications!
        }
        
        func requestAuthorization() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){
                (granted, error)in
            }
        }
    }
}

protocol LocalNotificationModel_Interface {
    func scheduleNotification(_ notification: LocalNotification)
    func cancelNotification(identifier: String)
    func cancelAllNotifications()
    var notifications: [LocalNotification] {get}
}


class LocalNotification {
    var message: String?
    var fireDate: Date?
    var identifier: String
    var userInfo: [AnyHashable : Any]?
    
    init(message: String?, fireDate: Date? = nil, identifier: String = NSUUID().uuidString, userInfo: [AnyHashable : Any]? = nil) {
        self.message = message
        self.fireDate = fireDate
        self.identifier = identifier
        self.userInfo = userInfo
    }
    
    @available(iOS 10.0, *)
    convenience init(request: UNNotificationRequest) {
        let trigger = request.trigger as? UNCalendarNotificationTrigger
        self.init(message: request.content.body, fireDate: trigger?.dateComponents.date, identifier: request.identifier, userInfo: request.content.userInfo)
    }
    
    func register() {
        LocalNotificationModel.instance.scheduleNotification(self)
    }
    
    func cancel() {
        LocalNotificationModel.instance.cancelNotification(identifier: self.identifier)
    }
    
    fileprivate var uiLocalNotification: UILocalNotification {
        let notification = UILocalNotification()
        notification.alertBody = self.message
        notification.fireDate = self.fireDate
        notification.userInfo = self.userInfo
        notification.identifier = self.identifier

        return notification
    }
    
    @available(iOS 10.0, *)
    var notificationrequest: UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.body = self.message ?? ""
        content.userInfo = self.userInfo ?? [:]

        //HACK: UNCalendarNotificationTrigger を使いたいところだが、iOS10.0 にて DateComponent に year が入っている場合にのみ発火されないバグを確認（実機のみ、iOS10.2.1では修正済み？）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.fireDate?.timeIntervalSinceNow ?? 0, repeats: false)
        return UNNotificationRequest(identifier: self.identifier, content: content, trigger: trigger)
    }
}

fileprivate extension UILocalNotification {
    var identifier: String {
        get {
            return self.userInfo?["identifier"] as? String ?? ""
        }
        set {
            if var info = userInfo {
                info["identifier"] = newValue
            } else {
                self.userInfo = ["identifier": newValue]
            }
        }
    }
    
    var localNotification: LocalNotification {
        return LocalNotification(message: self.alertBody, fireDate: self.fireDate, identifier: self.identifier)
    }
    
}

//HACK: なぜかObj−C側へのヘッダでコンパイルエラーが発生する
//@available(iOS 10.0, *)
//fileprivate extension UNNotificationRequest {
//    var localNotification: LocalNotification {
//        let trigger = self.trigger as? UNCalendarNotificationTrigger
//        return LocalNotification(message: self.content.body, fireDate: trigger?.dateComponents.date, id: self.identifier)
//    }
//}
