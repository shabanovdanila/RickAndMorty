//
//  CustomFontSize.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 03.07.2025.
//

import UIKit

extension UIFont {
    static func customFont(weight: CGFloat, size: CGFloat) -> UIFont {
        let fontName: String
        switch weight {
        case 100: fontName = "IBMPlexSans-Thin"
        case 200: fontName = "IBMPlexSans-ExtraLight"
        case 300: fontName = "IBMPlexSans-Light"
        case 400: fontName = "IBMPlexSans-Regular"
        case 500: fontName = "IBMPlexSans-Medium"
        case 600: fontName = "IBMPlexSans-SemiBold"
        case 700: fontName = "IBMPlexSans-Bold"
        default: fontName = "IBMPlexSans-Regular"
        }
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: UIFont.Weight(rawValue: weight))
    }
}
