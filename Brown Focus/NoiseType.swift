//
//  NoiseType.swift
//  Brown Focus
//
//  Created by Brandon Seaver on 3/21/25.
//

import SwiftUI

enum NoiseType: String, CaseIterable, Identifiable {
    case brown = "Brown"
    case green = "Green"
    case white = "White"
    case grey = "Grey"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .brown:
            return "Deep, rumbling noise that reduces higher frequencies"
        case .white:
            return "Equal intensity across all frequencies"
        case .grey:
            return "White noise adjusted to match human hearing perception"
        case .green:
            return "Ocean-like waves with gentle, periodic rhythm"
        }
    }
    
    var color: Color {
        switch self {
        case .brown: return Color.brown
        case .white: return Color.white
        case .grey: return Color.gray
        case .green: return Color.green
        }
    }
}
