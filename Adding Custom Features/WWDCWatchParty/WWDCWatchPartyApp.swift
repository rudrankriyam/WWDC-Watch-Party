//
//  WWDCWatchPartyApp.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 11/04/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI
import UIKit
import UserNotifications

@main
struct WWDCWatchPartyApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {
    registerForPushNotifications()
  }

  var body: some Scene {
    WindowGroup {
      SessionsView(sessions: .sampleSessions)
        .preferredColorScheme(.dark)
    }
  }

  private func registerForPushNotifications() {
    Task {
      let granted = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
      guard let granted, granted else { return }
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
    let token = tokenParts.joined()
    debugPrint("Device Token: \(token)")

    UserDefaults.standard.set(token, forKey: "pushNotificationToken")
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    debugPrint("Failed to register for notifications: \(error)")
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
}

extension Notification.Name {
  static let newSessionStarting = Notification.Name("newSessionStarting")
  static let participantJoined = Notification.Name("participantJoined")
}
