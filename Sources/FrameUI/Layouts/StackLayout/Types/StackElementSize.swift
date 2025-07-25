//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


/// Describes how a stack element should be sized within a stack layout.
///
/// - `fixed`: Assigns an exact, unchanging size. This value is not influenced by the parent or other elements.
///
/// - `weighted`: Distributes the remaining space (after fixed and relative sizes are accounted for)
///   proportionally based on the element’s `size` value relative to the total weight of all weighted elements.
///
/// - `relative`: Sets the size as a fraction of the parent’s size along a specified axis.
///   By default, the axis is the same as the layout direction (main or cross),
///   but it can be overridden using `.oppositeAxis`.
///
/// - `copy`: Uses the view’s existing frame size. This is useful when the layout should reflect
///   the view's predefined dimensions without modification.
public enum StackElementSize {
    case fixed(size: CGFloat)
    case weighted(size: CGFloat)
    case _relative(size: CGFloat, axis: RelativeAxis)
    case copy
    
    public static func relative(size: CGFloat, to axis: RelativeAxis = .currentAxis) -> StackElementSize {
        return ._relative(size: size, axis: axis)
    }
}
