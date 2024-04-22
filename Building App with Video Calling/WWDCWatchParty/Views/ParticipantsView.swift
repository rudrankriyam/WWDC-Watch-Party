//
//  ParticipantsView.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 22/04/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct ParticipantsView: View {
  var call: Call
  var participants: [CallParticipant]
  var onChangeTrackVisibility: (CallParticipant?, Bool) -> Void
  var size: CGSize = .init(width: 150, height: 150)

  var body: some View {
    VStack {
      Spacer()

      if !participants.isEmpty {
        ScrollView(.horizontal) {
          HStack {
            ForEach(participants) { participant in
              VideoRendererView(id: participant.id, size: size) { videoRenderer in
                videoRenderer.handleViewRendering(for: participant, onTrackSizeUpdate: { _, _ in })
              }
              .frame(width: size.width, height: size.height)
              .clipShape(RoundedRectangle(cornerRadius: 8))

              .onAppear { onChangeTrackVisibility(participant, true) }
              .onDisappear { onChangeTrackVisibility(participant, false) }
            }
          }
        }
      } else {
        Color.black
      }
    }
  }
}
