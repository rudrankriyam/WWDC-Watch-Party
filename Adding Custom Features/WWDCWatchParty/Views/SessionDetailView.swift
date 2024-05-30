//
//  SessionDetailView.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 22/04/24.
//

import SwiftUI
import StreamVideo
import AVKit
import StreamVideoSwiftUI

struct SessionDetailView: View {
  let session: Session

  private var client: StreamVideo
  @State private var callCreated: Bool = false
  @State private var player: AVPlayer?
  @State private var syncTimer: Timer?

  @ObservedObject var viewModel: CallViewModel

  init(session: Session) {
    self.session = session

    self.client = StreamVideo(
      apiKey: "your_api_key",
      user: .guest("guest_name"),
      token: .init(stringLiteral: "your_token")
    )

    self.viewModel = .init()
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

      CallContainer(viewFactory: DefaultViewFactory.shared, viewModel: viewModel)

      if callCreated {
        Text("Watch party \(viewModel.call?.callId ?? "") has \(viewModel.call?.state.participants.count ?? 0) developers!")
          .font(.footnote)
          .foregroundColor(.secondary)
      } else {
        VStack {
          ProgressView()
          Text("Loading video feed...")
        }
      }
    }
    .navigationTitle(session.title)
    .onAppear {
      setupAudioSession()
      setupAVPlayer()

      Task {
        guard !callCreated else { return }
        guard viewModel.call == nil else { return }
        viewModel.joinCall(callType: .default, callId: "session_\(session.id)")

        callCreated = true

        subscribeToCustomEvents()
      }
    }
  }

  private func subscribeToCustomEvents() {
    Task {
      if let call = viewModel.call {
        for await event in call.subscribe(for: CustomVideoEvent.self) {
          handleCustomEvent(event)
        }
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
        let response = try await viewModel.call?.sendCustomEvent(customEventData)
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
}

