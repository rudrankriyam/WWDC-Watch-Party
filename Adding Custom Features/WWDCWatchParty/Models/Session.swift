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
      id: 10133,
      title: "Bring your app to Siri",
      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2024/10133/4/8167BB3B-00DE-4F39-A88C-4A719DF29D02/cmaf.m3u8")!,
      thumbnailURL: URL(string: "https://devimages-cdn.apple.com/wwdc-services/images/C03E6E6D-A32A-41D0-9E50-C3C6059820AA/9261/9261_wide_250x141_2x.jpg")!
    ),
    Session(
      id: 10109,
      title: "Meet SwiftUI for spatial computing",
      videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2023/10109/4/F4A066BD-28D9-4CF8-AAF3-D35EA776504F/cmaf.m3u8")!,
      thumbnailURL: URL(string: "https://i.ytimg.com/vi/HEE8qjXQYPc/hqdefault.jpg?sqp=-oaymwEjCNACELwBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLClaHmeXbjjIGD7Q5qazy1516u4PA")!
    )
  ]
}
