//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 27..
//

import UIKit


public struct BoxElement {
    public var view: UIView
    public var alignment: BoxElementAlignment?
    public var width: BoxElementSize
    public var heigth: BoxElementSize
    public var isHidden: Bool
    
    public init(
        view: UIView,
        alignment: BoxElementAlignment? = nil,
        width: BoxElementSize = .relative(multiplier: 1),
        heigth: BoxElementSize = .relative(multiplier: 1),
        isHidden: Bool = false
    ) {
        self.view = view
        self.alignment = alignment
        self.width = width
        self.heigth = heigth
        self.isHidden = isHidden
    }

    public func with(
        view: UIView? = nil,
        alignment: BoxElementAlignment? = nil,
        width: BoxElementSize? = nil,
        height: BoxElementSize? = nil,
        isHidden: Bool? = nil
    ) -> BoxElement {
        var updated = self
        
        updated.view = view ?? self.view
        updated.alignment = alignment ?? self.alignment
        updated.width = width ?? self.width
        updated.heigth = height ?? self.heigth
        updated.isHidden = isHidden ?? self.isHidden
        
        return updated
    }
}
