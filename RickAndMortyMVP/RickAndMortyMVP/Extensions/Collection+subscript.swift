//
//  Collection+subscript.swift
//  RickAndMortyMVP
//
//  Created by Данила Шабанов on 23.06.2025.
//
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
