//
//  ReactionButtonsView.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 17/07/24.
//

import SwiftUI

struct ReactionButtonsView: View {
  let onReactionSent: (Reaction) -> Void

  var body: some View {
    HStack {
      ForEach(Reaction.allCases, id: \.self) { reaction in
        Button(action: {
          onReactionSent(reaction)
        }) {
          Text(reaction.rawValue)
            .font(.system(size: 24))
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
        }
      }
    }
  }
}
