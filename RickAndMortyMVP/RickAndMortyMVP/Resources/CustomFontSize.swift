//
//  CustomFontSize.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 03.07.2025.
//

import UIKit

extension UIFont.Weight {
    var semanticName: String {
        switch self {
        case .ultraLight: return ".ultraLight"
        case .thin: return ".thin"
        case .light: return ".light"
        case .regular: return ".regular"
        case .medium: return ".medium"
        case .semibold: return ".semibold"
        case .bold: return ".bold"
        case .heavy: return ".heavy"
        case .black: return ".black"
        default: return ".regular" // fallback
        }
    }
}

extension UIFont {
    static func font(weight: CGFloat) -> String {
        let fontWeight = UIFont.Weight(rawValue: weight)
        return fontWeight.semanticName
    }
}
