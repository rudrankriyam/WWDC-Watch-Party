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

  var body: some Scene {
    WindowGroup {
      SessionsView(sessions: .sampleSessions)
        .preferredColorScheme(.dark)
    }
  }
}
