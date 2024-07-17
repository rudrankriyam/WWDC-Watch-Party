//
//  SessionsView.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 22/04/24.
//

import SwiftUI

struct SessionsView: View {
  let sessions: [Session]
  @State private var showNewSessionAlert = false

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack {
          ForEach(sessions) { session in
            NavigationLink(destination: SessionDetailView(session: session)) {
              VStack {
                AsyncImage(url: session.thumbnailURL) { image in
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                } placeholder: {
                  ProgressView()
                }

                Text(session.title)
                  .font(.headline)
                  .multilineTextAlignment(.center)
              }
            }
            .buttonStyle(.plain)
          }
        }
        .padding()
      }
      .navigationTitle("WWDC Sessions")
    }
    .onReceive(NotificationCenter.default.publisher(for: .newSessionStarting)) { _ in
      showNewSessionAlert = true
    }
    .alert(isPresented: $showNewSessionAlert) {
      Alert(title: Text("New Session Starting"), message: Text("A new WWDC session is about to begin!"), dismissButton: .default(Text("OK")))
    }
  }
}

#Preview("SessionsView") {
  SessionsView(sessions: .sampleSessions)
}
