//
//  SessionDetailView.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 22/04/24.
//

import SwiftUI
import StreamVideo
import AVKit

struct SessionDetailView: View {
  let session: Session

  @ObservedObject var state: CallState
  private var client: StreamVideo
  @State private var call: Call
  @State private var callCreated: Bool = false
  @State private var player: AVPlayer?
  @State private var syncTimer: Timer?

  init(session: Session) {
    self.session = session

    self.client = StreamVideo(
      apiKey: "your_api_key",
      user: .guest("guest_name"),
      token: .init(stringLiteral: "your_token")
    )

    let call = client.call(callType: "default", callId: "session_\(session.id)")

    self.call = call
    self.state = call.state
  }

  var body: some View {
    VStack {
      if let player {
        VideoPlayer(player: player)
          .frame(height: 300)
          .onDisappear {
            player.replaceCurrentItem(with: nil)
          }
          .onReceive(player.publisher(for: \.timeControlStatus)) { status in
            if status == .playing {
              syncTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                sendPlaybackPositionEvent()
              }
            } else {
              syncTimer?.invalidate()
              syncTimer = nil
            }
          }
      }

      if let localParticipant = call.state.localParticipant {
        ParticipantsView(
          call: call,
          participants: [localParticipant] + call.state.remoteParticipants,
          onChangeTrackVisibility: changeTrackVisibility(_:isVisible:)
        )
      }

      if callCreated {
        Text("Call \(call.callId) has \(call.state.participants.count) participants")
          .font(.system(size: 30))
          .foregroundColor(.blue)
      } else {
        Text("loading...")
      }
    }
    .navigationTitle(session.title)
    .onAppear {
      setupAudioSession()
      setupAVPlayer()

      Task {
        guard !callCreated else { return }
        try await call.join(create: true)
        callCreated = true

        subscribeToCustomEvents()
      }
    }
  }

  private func subscribeToCustomEvents() {
    Task {
      for await event in call.subscribe(for: CustomVideoEvent.self) {
        handleCustomEvent(event)
      }
    }
  }

  private func handleCustomEvent(_ event: CustomVideoEvent) {
    if let position = event.custom["position"]?.numberValue {
      syncPlaybackPosition(to: position)
    }
  }

  private func syncPlaybackPosition(to position: Double) {
    let time = CMTime(seconds: position, preferredTimescale: 1000)
    player?.seek(to: time)
  }

  private func sendPlaybackPositionEvent() {
    guard let player = player else { return }
    Task {
      let customEventData: [String: RawJSON] = [
        "type": .string("playbackPosition"),
        "position": .number(player.currentTime().seconds)
      ]

      do {
        let response = try await call.sendCustomEvent(customEventData)
        print("SUCCESS SENT RESPONSE", response)
      } catch {
        print("Error sending custom event: \(error)")
      }
    }
  }

  private func setupAVPlayer() {
    let asset = AVAsset(url: session.videoURL)
    let playerItem = AVPlayerItem(asset: asset)
    player = AVPlayer(playerItem: playerItem)
  }

  private func setupAudioSession() {
    let audioSession = AVAudioSession.sharedInstance()

    do {
      try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
      try audioSession.setActive(true)
    } catch {
      print("Failed to set up audio session: \(error)")
    }
  }

  private func changeTrackVisibility(_ participant: CallParticipant?, isVisible: Bool) {
    guard let participant else { return }
    Task {
      await call.changeTrackVisibility(for: participant, isVisible: isVisible)
    }
  }
}
