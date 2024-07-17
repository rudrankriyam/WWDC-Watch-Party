//
//  WWDC24Theme.swift
//  WWDCWatchParty
//
//  Created by Rudrank Riyam on 17/07/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct WWDC24Theme {
  static func createAppearance() -> Appearance {
    var colors = Colors()

    let gradientColors: [UIColor] = [.red, .purple, .blue, .cyan, .purple]
    let gradientColor = UIColor.gradient(colors: gradientColors, from: .leading, to: .trailing)

    colors.tintColor = Color(gradientColor)
    colors.text = .white
    colors.textInverted = .black
    colors.background = UIColor.black
    colors.background1 = UIColor(white: 0.1, alpha: 1.0)
    colors.textLowEmphasis = UIColor(white: 0.7, alpha: 1.0)
    colors.callBackground = UIColor.black
    colors.participantBackground = UIColor(white: 0.15, alpha: 1.0)
    colors.lobbyBackground = Color.black
    colors.lobbySecondaryBackground = Color(white: 0.15)
    colors.primaryButtonBackground = Color(gradientColor)
    colors.callControlsBackground = Color(white: 0.2)
    colors.livestreamBackground = Color.black.opacity(0.8)
    colors.participantInfoBackgroundColor = Color.black.opacity(0.6)

    var fonts = Fonts()
    fonts.caption1 = Font.custom("SFProDisplay-Regular", size: 12)
    fonts.footnoteBold = Font.custom("SFProDisplay-Bold", size: 13)
    fonts.footnote = Font.custom("SFProDisplay-Regular", size: 13)
    fonts.subheadline = Font.custom("SFProDisplay-Regular", size: 15)
    fonts.subheadlineBold = Font.custom("SFProDisplay-Bold", size: 15)
    fonts.body = Font.custom("SFProDisplay-Regular", size: 17)
    fonts.bodyBold = Font.custom("SFProDisplay-Bold", size: 17)
    fonts.bodyItalic = Font.custom("SFProDisplay-Italic", size: 17)
    fonts.headline = Font.custom("SFProDisplay-Semibold", size: 17)
    fonts.headlineBold = Font.custom("SFProDisplay-Bold", size: 17)
    fonts.title = Font.custom("SFProDisplay-Bold", size: 28)
    fonts.title2 = Font.custom("SFProDisplay-Regular", size: 22)
    fonts.title3 = Font.custom("SFProDisplay-Regular", size: 20)
    fonts.emoji = Font.custom("SFProDisplay-Regular", size: 50)

    return Appearance(colors: colors, fonts: fonts)
  }
}

extension UIColor {
  static func gradient(colors: [UIColor], from startPoint: UnitPoint, to endPoint: UnitPoint) -> UIColor {
    UIColor { traitCollection in
      let bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
      let renderer = UIGraphicsImageRenderer(bounds: bounds)
      let image = renderer.image { context in
        let cgContext = context.cgContext
        let cgColors = colors.map { $0.cgColor }
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: nil) else {
          return
        }

        let start = CGPoint(x: startPoint.x * bounds.width, y: startPoint.y * bounds.height)
        let end = CGPoint(x: endPoint.x * bounds.width, y: endPoint.y * bounds.height)

        cgContext.drawLinearGradient(gradient, start: start, end: end, options: [])
      }
      return UIColor(patternImage: image)
    }
  }
}
