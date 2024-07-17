//
//  Reaction.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 17/07/24.
//

import Foundation

enum Reaction: String, CaseIterable {
  case thumbsUp = "👍"
  case heart = "❤️"
  case party = "🎉"
  case mindBlown = "🤯"
  case questionMark = "❓"

  init?(emojiCode: String) {
    switch emojiCode {
      case ":thumbsup:": self = .thumbsUp
      case ":heart:": self = .heart
      case ":tada:": self = .party
      case ":exploding_head:": self = .mindBlown
      case ":question:": self = .questionMark
      default: return nil
    }
  }

  var emojiCode: String {
    switch self {
      case .thumbsUp: return ":thumbsup:"
      case .heart: return ":heart:"
      case .party: return ":tada:"
      case .mindBlown: return ":exploding_head:"
      case .questionMark: return ":question:"
    }
  }
}
