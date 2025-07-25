//
//  Untitled.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


/// Determines whether to use the current or the opposite axis for a calculation.
///
/// This enum is used by the `.relative` element size where the user can
/// determine whether the size should be relative to the current axis or the opposite one.
///  You can read more about it at the `StackElementSize`.
public enum RelativeAxis {
    case currentAxis
    case oppositeAxis
}
