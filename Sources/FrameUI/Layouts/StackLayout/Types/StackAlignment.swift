//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


/// Defines the alignment of individual elements within the stack layout.
///
/// In a vertical stack:
/// - `start` aligns to the top,
/// - `center` aligns to the center,
/// - `end` aligns to the bottom.
///
/// In a horizontal stack:
/// - `start` aligns to the left,
/// - `center` aligns to the center,
/// - `end` aligns to the right.
public enum StackAlignment {
    case start
    case center
    case end
}
