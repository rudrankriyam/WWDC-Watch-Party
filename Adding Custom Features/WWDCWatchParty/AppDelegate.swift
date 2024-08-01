//
//  AppDelegate.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 29/07/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    setupRemoteNotifications()
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    debugPrint("Device Token: \(token)")

    UserDefaults.standard.set(token, forKey: "pushNotificationToken")
  }

  func userNotificationCenter( _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    debugPrint("push notification received \(response.notification.request.content)")
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    debugPrint("Failed to register for notifications: \(error)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    debugPrint("didReceiveRemoteNotification ", userInfo)

    if let aps = userInfo["aps"] as? [String: Any] {
      if let alert = aps["alert"] as? [String: Any], let body = alert["body"] as? String {
        if body.contains("New session starting") {
          NotificationCenter.default.post(name: .newSessionStarting, object: nil)
        } else if body.contains("joined the watch party") {
          NotificationCenter.default.post(name: .participantJoined, object: nil)
        }
      }
    }

    completionHandler(.newData)
  }

  func setupRemoteNotifications() {
    Task {
      let granted = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
      guard let granted, granted else { return }
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}

extension Notification.Name {
  static let newSessionStarting = Notification.Name("newSessionStarting")
  static let participantJoined = Notification.Name("participantJoined")
}
