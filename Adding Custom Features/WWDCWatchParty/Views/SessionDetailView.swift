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

  @State private var streamVideoUI: StreamVideoUI

  @State private var callCreated: Bool = false
  @State private var player: AVPlayer?
  @State private var syncTimer: Timer?
  private let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiS3lsZV9LYXRhcm4iLCJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0t5bGVfS2F0YXJuIiwiaWF0IjoxNzIxMjA0MTQ0LCJleHAiOjE3MjE4MDg5NDl9.uaM9VaHH3F5G2vg_d8949Bxko0z8u5iIZktYGeU6NNI"
  @State private var reactions: [Reaction] = []

  @ObservedObject var viewModel: CallViewModel

  init(session: Session) {
    self.session = session
    let appearance = WWDC24Theme.createAppearance()

    let streamVideo = StreamVideo(
      apiKey: "mmhfdzb5evj2",
      user: .init(id: UUID().uuidString, name: "Rudrank Riyam"),
      token: .init(stringLiteral: token)
    )

    streamVideoUI = StreamVideoUI(streamVideo: streamVideo, appearance: appearance)

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

      ReactionButtonsView(onReactionSent: { reaction in
        sendReaction(reaction)
      })

      ZStack {
        ForEach(reactions.indices, id: \.self) { index in
          ReactionView(reaction: reactions[index])
            .transition(.opacity)
        }
      }

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
        subscribeToReactionEvents()
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

  private func subscribeToReactionEvents() {
    Task {
      if let call = viewModel.call {
        for await event in call.subscribe(for: CallReactionEvent.self) {
          if let emojiCode = event.reaction.emojiCode, let reaction = Reaction(emojiCode: emojiCode) {
            self.reactions.append(reaction)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              self.reactions.removeFirst()
            }
          }
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
        debugPrint("SUCCESS SENT RESPONSE", response)
      } catch {
        debugPrint("Error sending custom event: \(error)")
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
      debugPrint("Failed to set up audio session: \(error)")
    }
  }

  private func sendReaction(_ reaction: Reaction) {
    Task {
      do {
        let response = try await viewModel.call?.sendReaction(type: "call.reaction_new", emojiCode: reaction.emojiCode)
        debugPrint("Reaction sent successfully: \(String(describing: response?.reaction))")
      } catch {
        debugPrint("Error sending reaction: \(error)")
      }
    }
  }
}

struct ReactionView: View {
  let reaction: Reaction

  @State private var offset: CGFloat = 0
  @State private var opacity: Double = 1

  var body: some View {
    Text(reaction.rawValue)
      .font(.system(size: 40))
      .offset(y: offset)
      .opacity(opacity)
      .onAppear {
        withAnimation(.easeOut(duration: 2)) {
          offset = -100
          opacity = 0
        }
      }
  }
}
