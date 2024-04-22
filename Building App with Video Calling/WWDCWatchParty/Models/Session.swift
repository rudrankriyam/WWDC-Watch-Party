//
//  Session.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 22/04/24.
//

import Foundation

struct Session: Identifiable {
  let id: Int
  let title: String
  let videoURL: URL
  let thumbnailURL: URL
}

extension [Session] {
  static let sampleSessions: Self = [
    Session(
      id: 101,
      title: "WWDC 2023 Keynote",
      videoURL: URL(string: "https://events-delivery.apple.com/0105cftwpxxsfrpdwklppzjhjocakrsk/m3u8/vod_index-PQsoJoECcKHTYzphNkXohHsQWACugmET.m3u8")!,
      thumbnailURL: URL(string: "https://i.ytimg.com/vi/GYkq9Rgoj8E/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAI0BvhdevIRJS89JD9YnXlbsh20w")!
    ),
    Session(
      id: 10072,
      title: "Principles of spatial design",
      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10072/5/C43DFF91-F057-43E1-891F-41E6D5C01716/cmaf.m3u8")!,
      thumbnailURL: URL(string: "https://i.ytimg.com/vi/Q1aJy1Hwjp8/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLBydTO2C6nUmnN4X_zC66dH8QW2FQ")!
    ),
    Session(
      id: 10109,
      title: "Meet SwiftUI for spatial computing",
      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10109/4/F4A066BD-28D9-4CF8-AAF3-D35EA776504F/cmaf.m3u8")!,
      thumbnailURL: URL(string: "https://i.ytimg.com/vi/HEE8qjXQYPc/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLClaHmeXbjjIGD7Q5qazy1516u4PA")!
    )
  ]
}
