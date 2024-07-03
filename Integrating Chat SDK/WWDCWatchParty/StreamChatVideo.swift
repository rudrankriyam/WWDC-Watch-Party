//
//  StreamChatVideo.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 04/07/24.
//

import StreamChat
import StreamChatSwiftUI
import StreamVideo
import StreamVideoSwiftUI

class StreamChatVideo {
  let chatClient: ChatClient
  let streamChatUI: StreamChat
  let streamVideo: StreamVideo
  let streamVideoUI: StreamVideoUI

  init(
    apiKey: String,
    user: User,
    token: UserToken
  ) {
    // Initialize StreamVideo
    streamVideo = StreamVideo(
      apiKey: apiKey,
      user: user,
      token: token
    )
    streamVideoUI = StreamVideoUI(streamVideo: streamVideo)

    // Initialize StreamChat
    chatClient = ChatClient(config: .init(apiKeyString: apiKey))
    streamChatUI = StreamChat(chatClient: chatClient)

    // Connect the chat user
    let userInfo = UserInfo(
      id: user.id,
      name: user.name,
      imageURL: user.imageURL,
      extraData: [:]
    )

    chatClient.connectUser(userInfo: userInfo, token: Token(stringLiteral: token.rawValue)) { error in
      if let error = error {
        print("Error connecting chat user: \(error)")
      } else {
        print("Chat user connected successfully")
      }
    }
  }

  func logout() async {
    await streamVideo.disconnect()
    await  chatClient.logout()
  }
}
