//
//  StackElement.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import UIKit

public enum StackElementKind {
    case userCreated
    case filler
    case gap
    case separator
}

/// Represents an element to be placed within the stack layout.
///
/// The `view` is the actual UIView to be arranged according to the rules
/// defined by its associated enums (e.g., alignment and sizing).
@MainActor
public struct StackElement {
    public private(set) var kind: StackElementKind
    public var view: UIView
    public var alignment: StackAlignment?
    public var mainSize: StackElementSize
    public var crossSize: StackElementSize
    public var isHidden: Bool
    
    public init(
        view: UIView,
        alignment: StackAlignment? = nil,
        mainSize: StackElementSize = .weighted(size: 1),
        crossSize: StackElementSize = .relative(size: 1),
        isHidden: Bool = false
    ) {
        self.kind = .userCreated
        self.view = view
        self.alignment = alignment
        self.mainSize = mainSize
        self.crossSize = crossSize
        self.isHidden = isHidden
    }

    public static func makeFiller() -> StackElement {
        var filler = StackElement(view: UIView())
        filler.kind = .filler
        return filler
    }
    
    public static func makeGap(size: CGFloat = 0) -> StackElement {
        var gap = StackElement(view: UIView(), mainSize: .fixed(size: size), crossSize: .fixed(size: 0))
        gap.kind = .gap
        return gap
    }
    
    public static func makeSeparator(color: UIColor = .systemGray) -> StackElement {
        let seperator = UIView()
        seperator.backgroundColor = color
        var separator = StackElement(view: seperator, mainSize: .fixed(size: 1))
        separator.kind = .separator
        return separator
    }
    
    public func with(
        view: UIView? = nil,
        alignment: StackAlignment? = nil,
        mainSize: StackElementSize? = nil,
        crossSize: StackElementSize? = nil,
        isHidden: Bool? = nil
    ) -> StackElement {
        var updated = self
        
        updated.view = view ?? self.view
        updated.alignment = alignment ?? self.alignment
        updated.mainSize = mainSize ?? self.mainSize
        updated.crossSize = crossSize ?? self.crossSize
        updated.isHidden = isHidden ?? self.isHidden
        
        return updated
    }
}
