//
//  WWDCWatchPartyApp.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 11/04/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

@main
struct WWDCWatchPartyApp: App {
  var body: some Scene {
    WindowGroup {
      SessionsView(sessions: .sampleSessions)
        .preferredColorScheme(.dark)
    }
  }
}
