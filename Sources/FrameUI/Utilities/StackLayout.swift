//
//  StackLayout.swift
//  IconCraft
//
//  Created by Krisztián Szénási on 2025. 07. 22..
//

import UIKit

/// Specifies the direction of element flow in a stack layout.
///
/// Used by `StackLayout` to define whether elements are arranged
/// horizontally or vertically.
public enum StackDirection {
    case vertical
    case horizontal
}

public enum RelativeAxis {
    case currentAxis
    case oppositeAxis
}


/// Defines the arrangement strategy for elements in a stack layout.
///
/// This enum is used by `StackLayout` to determine how its child elements are positioned.
///
/// The available options are inspired by grid systems in web development and
/// arrangement patterns from Jetpack Compose on Android.
/// For a conceptual reference, see the Jetpack Compose documentation:
/// https://developer.android.com/reference/kotlin/androidx/compose/foundation/layout/Arrangement
public enum StackArrangement {
    case start
    case center
    case end
    case spaceBetween
    case spaceAround
    case spaceEvenly
}


/// Defines how an element should be sized within the stack layout.
///
/// - `fixed`: Uses an exact size value on the main axis (width for horizontal stacks, height for vertical).
///   This size is not affected by the parent or other elements.
/// - `weighted`: Shares the remaining space after all `fixed` sizes are applied.
///   Each element with a weight will receive a portion proportional to its `size` value
///   compared to the total weight of all such elements.
/// - `relative`: Sizes the element as a fraction of the total parent size on the main axis.
///   For example, `relative(size: 0.5)` in a vertical stack will make the view occupy half the parent height.
/// - `copy`: Copies the size directly from the view’s current intrinsic or frame value,
///   depending on context. Useful when layout should reflect the view's content or predefined frame.
public enum StackElementSize {
    case fixed(size: CGFloat)
    case weighted(size: CGFloat)
    case _relative(size: CGFloat, axis: RelativeAxis)
    case copy
    
    public static func relative(size: CGFloat, to axis: RelativeAxis = .currentAxis) -> StackElementSize {
        return ._relative(size: size, axis: axis)
    }
}


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


/// Represents an element to be placed within the stack layout.
///
/// The `view` is the actual UIView to be arranged according to the rules
/// defined by its associated enums (e.g., alignment and sizing).
@MainActor
public struct StackElement {
    public var view: UIView
    public var alignment: StackAlignment
    public var mainSize: StackElementSize
    public var crossSize: StackElementSize
    public var isHidden: Bool = false
    
    public init(
        view: UIView,
        alignment: StackAlignment = .center,
        mainSize: StackElementSize = .weighted(size: 1),
        crossSize: StackElementSize = .relative(size: 1)
    ) {
        self.view = view
        self.alignment = alignment
        self.mainSize = mainSize
        self.crossSize = crossSize
    }

    public static func makeFiller() -> StackElement {
        return StackElement(view: UIView())
    }
    
    public static func makeGap(mainLength: CGFloat = 0, crossLength: CGFloat = 0) -> StackElement {
        return StackElement(view: UIView(), mainSize: .fixed(size: mainLength), crossSize: .fixed(size: crossLength))
    }
    
    public static func makeSeparator(color: UIColor = .systemGray) -> StackElement {
        let seperator = UIView()
        seperator.backgroundColor = color
        return StackElement(view: seperator, mainSize: .fixed(size: 1))
    }
}


/// Arranges a list of views horizontally or vertically with customizable options.
///
/// See `StackElement` and its related enums for details on available configuration options.
@MainActor
public struct StackLayout {

    public static func layoutStackedSubviews(
        elements: [StackElement],
        in parent: UIView,
        direction: StackDirection,
        arrangement: StackArrangement = .spaceEvenly
    ) {
        let elements = insertSpacing(for: arrangement, into: handleHiddenElements(elements: elements))
        let totalWeight = calculateTotalWeight(elements: elements)
        
        let parentMainAxisLength = ((direction == .vertical) ? parent.frame.height : parent.frame.width)
        let parentCorssAxisLength = (direction == .vertical) ? parent.frame.width : parent.frame.height
        
        let parentRemainingMainAxisLength = parentMainAxisLength - calculateTotalFixLength(
            elements: elements,
            direction: direction,
            parentMainLength: parentMainAxisLength,
            parentCrossLength: parentCorssAxisLength
        )
        
        var offset: CGFloat = 0

        for element in elements {
            let (mainLength, crossLength): (CGFloat, CGFloat)

            switch element.mainSize {
            case .fixed(let size):
                mainLength = size
            case .weighted(let weight):
                let sizePerWeight = parentRemainingMainAxisLength / totalWeight
                mainLength = sizePerWeight * weight
            case ._relative(let ratio, let axis):
                let axisLength = (axis == .currentAxis) ? parentMainAxisLength : parentCorssAxisLength
                mainLength = axisLength * ratio
            case .copy:
                mainLength = (direction == .horizontal) ? element.view.frame.width : element.view.frame.height
            }
            
            switch element.crossSize {
            case .fixed(let size):
                crossLength = size
            case .weighted:
                // weighted does not really make sense for cross axis
                // since there will be only one element so no matter
                // what it would fill the entire space
                crossLength = parentCorssAxisLength
            case ._relative(let ratio, let axis):
                let axisLength = (axis == .currentAxis) ? parentCorssAxisLength : parentMainAxisLength
                crossLength = axisLength * ratio
            case .copy:
                crossLength = (direction == .horizontal) ? element.view.frame.height : element.view.frame.width
            }

            let (x, y, width, height): (CGFloat, CGFloat, CGFloat, CGFloat)

            switch direction {
            case .vertical:
                width = crossLength
                height = mainLength
                x = calculateOffset(alignment: element.alignment, childSize: width, parentSize: parent.frame.width)
                y = offset
                offset += height
            case .horizontal:
                width = mainLength
                height = crossLength
                x = offset
                y = calculateOffset(alignment: element.alignment, childSize: height, parentSize: parent.frame.height)
                offset += width
            }

            element.view.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    
    /// Handle hidden elements.
    ///
    /// Hidden elements are filtered out from the list to exclude them from layout calculations.
    /// Their `isHidden` property is also set to `true` to ensure they are not visible.
    private static func handleHiddenElements(elements: [StackElement]) -> [StackElement] {
        var updatedElements: [StackElement] = []
        for element in elements {
            if element.isHidden {
                element.view.isHidden = true
            } else {
                element.view.isHidden = false
                updatedElements.append(element)
            }
        }
        return updatedElements
    }
    
    /// Computes the ideal size needed to fit the given elements.
    ///
    /// Recommended usage: first call this method to calculate the fitting size,
    /// then set the parent’s `mainSize` and `crosSize` to `.copy`,
    /// and finally apply the returned size to the parent’s frame.
    public static func calculateFittingSize(
        for elements: [StackElement],
        parentSize: CGRect,
        direction: StackDirection
    ) -> CGSize {
        let elements = handleHiddenElements(elements: elements)
        var totalMain: CGFloat = 0
        var maxCross: CGFloat = 0
        
        let parentMainSize = (direction == .horizontal) ? parentSize.width : parentSize.height
        let parentCrossSize = (direction == .vertical) ? parentSize.height : parentSize.width

        for element in elements {
            let (main, cross): (CGFloat, CGFloat)

            switch element.mainSize {
            case .fixed(let size): main = size
            case .copy:
                main = (direction == .vertical) ? element.view.frame.height : element.view.frame.width
            case ._relative(size: let ratio, axis: let relativeAxis):
                let axisSize = (relativeAxis == .currentAxis) ? parentMainSize : parentCrossSize
                main = axisSize * ratio
            default:
                main = 0
            }

            switch element.crossSize {
            case .fixed(let size): cross = size
            case .copy:
                cross = (direction == .vertical) ? element.view.frame.width : element.view.frame.height
            case ._relative(size: let ratio, axis: let relativeAxis):
                let axisSize = (relativeAxis == .currentAxis) ? parentCrossSize : parentMainSize
                cross = axisSize * ratio
            // does not make sense for other sizes
            default:
                cross = 0
            }

            totalMain += main
            maxCross = max(maxCross, cross)
        }

        return (direction == .vertical)
            ? CGSize(width: maxCross, height: totalMain)
            : CGSize(width: totalMain, height: maxCross)
    }

    private static func calculateOffset(alignment: StackAlignment, childSize: CGFloat, parentSize: CGFloat) -> CGFloat {
        switch alignment {
        case .start: return 0
        case .center: return (parentSize - childSize) / 2
        case .end: return parentSize - childSize
        }
    }
    
    
    /// Inserts filler elements between existing elements to occupy remaining space.
    ///
    /// If the array contains a relative-sized element, no fillers are added since that element
    /// already consumes all available space.
    ///
    /// The layout behaves traditionally—see the array extensions for usage examples or the
    ///  `StackArrangement` enum.
    private static func insertSpacing(for arrangement: StackArrangement, into elements: [StackElement]) -> [StackElement]{
        guard !elements.contains(where: {
            if case .weighted = $0.mainSize { true } else { false }
        }) else {
            return elements
        }
        
        switch arrangement {
        case .start:
            return elements + [StackElement.makeFiller()]
        case .center:
            return [StackElement.makeFiller()] + elements + [StackElement.makeFiller()]
        case .end:
            return [StackElement.makeFiller()] + elements
        case .spaceBetween:
            return elements.insertBetween{ StackElement.makeFiller() }
        case .spaceAround:
            return elements.insertArround{ StackElement.makeFiller() }
        case .spaceEvenly:
            return elements.insertEvenly{ StackElement.makeFiller() }
        }
    }
    
    /// Calculates the total weight of relative-sized elements.
    ///
    /// Fixed-size stack elements are ignored in this calculation. This allows fixed and relative-sized elements
    /// to coexist. The space taken by fixed elements is excluded, and the remaining space is distributed
    /// proportionally among the relative elements based on their weights.
    private static func calculateTotalWeight(elements: [StackElement]) -> CGFloat {
        return elements.reduce(0) { sum, element in
            if case let .weighted(size: weight) = element.mainSize {
                return sum + weight
            } else {
                return sum
            }
        }
    }
    
    private static func calculateTotalFixLength(
        elements: [StackElement],
        direction: StackDirection,
        parentMainLength: CGFloat,
        parentCrossLength: CGFloat
    ) -> CGFloat {
        return elements.reduce(0) { sum, element in
            if case let .fixed(size: length) = element.mainSize {
                return sum + length
            } else if case .copy = element.mainSize {
                let copiedSize = (direction == .horizontal) ? element.view.frame.width : element.view.frame.height
                return sum + copiedSize
            }else if case let ._relative(size: ratio, axis: axis) = element.mainSize {
                let axisLength = (axis == .currentAxis) ? parentMainLength : parentCrossLength
                return sum + axisLength * ratio
            } else {
                return sum
            }
        }
    }
}
