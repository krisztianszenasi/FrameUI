//
//  FUIStackView.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import UIKit

public class FUIStackView: UIView {
    
    private var arrangedElements: [StackElement] = []
    
    public var elements: [StackElement] {
        didSet {
            reconfigure()
        }
    }
    public var direction: StackDirection {
        didSet {
            reconfigure()
        }
    }
    
    public var arrangement: StackArrangement {
        didSet {
            reconfigure()
        }
    }
    public var alignment: StackAlignment {
        didSet {
            reconfigure()
        }
    }
    
    private var visibleElements: [StackElement] {
        var visibleElements: [StackElement] = []
        for element in elements {
            if(element.isHidden) {
                element.view.isHidden = true
            } else {
                element.view.isHidden = false
                visibleElements.append(element)
            }
        }
        return visibleElements
    }
    
    private var hasWeighted: Bool {
        return elements.contains {
            if case .weighted = $0.mainSize { true } else { false }
        }
    }
    
    private var totalWeight: CGFloat {
        return arrangedElements.reduce(0) { sum, element in
            if case let .weighted(size: weight) = element.mainSize {
                return sum + weight
            } else {
                return sum
            }
        }
    }
    
    private var totalFixLength: CGFloat {
        return arrangedElements.reduce(0) { sum, element in
            switch(element.mainSize) {
            case .fixed(size: let size):
                return sum + size
            case .copy:
                return sum + element.view.frame.getMainSize(for: direction)
            case ._relative(size: let size, axis: let axis):
                let axisSize = (axis == .currentAxis) ? frame.getMainSize(for: direction) : frame.getCrossSize(for: direction)
                return sum + axisSize * size
            default:
                return sum
            }
        }
    }
    
    private var remainingLength: CGFloat {
        return frame.getMainSize(for: direction) - totalFixLength
    }
    
    public init(
        elements: [StackElement] = [],
        direction: StackDirection,
        arrangement: StackArrangement = .spaceBetween,
        alignment: StackAlignment = .center
    ) {
        self.elements = elements
        self.direction = direction
        self.arrangement = arrangement
        self.alignment = alignment
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        var offset: CGFloat = 0
        
        for element in arrangedElements {
            let mainSize = calculateMainSize(for: element)
            let crossSize = calculateCrossSize(for: element)
            let crossCoordinate = calculateCrossCoordinate(for: element, crossSize: crossSize)
            
            element.view.frame = (direction == .horizontal)
            ? CGRect.makeHorizontally(mc: offset, cc: crossCoordinate, ms: mainSize, cs: crossSize)
            : CGRect.makeVertically(mc: offset, cc: crossCoordinate, ms: mainSize, cs: crossSize)
            
            offset += mainSize
        }
    }
    
    private func configure() {
        addSubviews( elements.map{ $0.view } )
        // TODO:
        // Spacings are insterted into elemets list later on purpose so that
        // they won't get added as subviews since they are only needed for their
        // sizes, not as actual views. However, this approach could be improved by
        // introducing a cleaner mechanism - for example, using a custom helper that
        // checks the `.kind` of each element and skips adding non-visual ones in a
        // more explicit and maintainable way.
        insertSpacing()
    }
    
    
    /// Called whenever the layout setup changes.
    ///
    /// This approach keeps all visible views as subviews,
    /// allowing changes to be animated smoothly. It must be triggered manually,
    /// since some changes—like updating the arrangement—don’t involve adding or removing views.
    private func reconfigure() {
        insertSpacing()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
    /// Insert fillers based on the selected arrangement.
    ///
    /// This function only takes the visible elements into consideration.
    /// The original list is preserved in `elements`, while a new list called `arrangedElements`
    /// is created to keep user-created and framework-generated elements separate.
    /// If the original `elements` list contains any weighted elements, the arrangement is aborted,
    /// as such elements occupy the entire available space, making layout adjustments meaningless.
    private func insertSpacing() {
        if hasWeighted {
            arrangedElements = visibleElements
            return
        }
        
        switch arrangement {
        case .start:
            arrangedElements = visibleElements + [StackElement.makeFiller()]
        case .center:
            arrangedElements = [StackElement.makeFiller()] + visibleElements + [StackElement.makeFiller()]
        case .end:
            arrangedElements = [StackElement.makeFiller()] + visibleElements
        case .spaceBetween:
            arrangedElements = visibleElements.insertBetween{ StackElement.makeFiller() }
        case .spaceAround:
            arrangedElements = visibleElements.insertArround{ StackElement.makeFiller() }
        case .spaceEvenly:
            arrangedElements = visibleElements.insertEvenly{ StackElement.makeFiller() }
        }
    }
    
    private func calculateMainSize(for element: StackElement) -> CGFloat {
        switch element.mainSize {
        case .fixed(size: let size):
            return size
        case .weighted(size: let weight):
            let sizePerWeight = remainingLength / totalWeight
            return weight * sizePerWeight
        case ._relative(size: let ratio, axis: let axis):
            let axisSize = (axis == .currentAxis) ? frame.getMainSize(for: direction) : frame.getCrossSize(for: direction)
            return ratio * axisSize
        case .copy:
            return element.view.frame.getMainSize(for: direction)
        }
    }
    
    private func calculateCrossSize(for element: StackElement) -> CGFloat {
        switch element.crossSize {
        case .fixed(size: let size):
            return size
        case .weighted:
            return frame.width
        case ._relative(size: let ratio, axis: let axis):
            let axisSize = (axis == .currentAxis) ? frame.getCrossSize(for: direction) : frame.getMainSize(for: direction)
            return ratio * axisSize
        case .copy:
            return element.view.frame.getCrossSize(for: direction)
        }
    }
    
    private func calculateCrossCoordinate(for element: StackElement, crossSize: CGFloat) -> CGFloat {
        let parentCrossSize = frame.getCrossSize(for: direction)
        
        switch element.alignment ??  alignment {
        case .start: return 0
        case .center: return (parentCrossSize - crossSize) / 2
        case .end: return parentCrossSize - crossSize
        }
    }
}
