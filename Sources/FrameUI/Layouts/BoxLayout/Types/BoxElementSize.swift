//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 26..
//

import Foundation

/// Defines the reference side used for calculating a relative element size.
///
/// - `boxCurrentSide`: Refers to the same side being set on the parent box (e.g., width for width, height for height).
/// - `boxOppositeSide`: Refers to the opposite side on the parent box (e.g., height when setting width).
public enum BoxRelativeSizeTarget {
    case boxCurrentSide
    case boxOppositeSide
}

/// Represents how the size (width or height) of a box element is determined.
///
/// - `copy`: Uses the element’s existing frame size.
/// - `fixed`: Uses a fixed, explicit size.
/// - `_relative`: Calculates the size relative to a specified side, using a multiplier.
public enum BoxElementSize {
    case copy
    case fixed(size: CGFloat)
    case _relative(multiplier: CGFloat, relativeSide: BoxRelativeSizeTarget)
    
    /// Convenience method to define a relative size.
    /// Defaults to using the same side being set on the parent box.
    public static func relative(multiplier: CGFloat, to relativeSide: BoxRelativeSizeTarget = .boxCurrentSide) -> BoxElementSize {
        return ._relative(multiplier: multiplier, relativeSide: relativeSide)
    }
}
