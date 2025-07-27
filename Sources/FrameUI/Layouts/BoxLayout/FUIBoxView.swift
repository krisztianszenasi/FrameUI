//
//  FUIBoxView.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 27..
//

import UIKit

public class FUIBoxView: UIView {
    
    public var elements: [BoxElement] {
        didSet {
            reconfigure()
        }
    }
    
    public var alignment: BoxElementAlignment {
        didSet {
            reconfigure()
        }
    }
    
    public var visibleElements: [BoxElement] {
        var visibleElements: [BoxElement] = []
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
    
    public init(
        elements: [BoxElement] = [],
        alignment: BoxElementAlignment = .middleCenter
    ) {
        self.elements = elements
        self.alignment = alignment
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        for element in visibleElements {
            let width = calculateWidth(for: element)
            let height = calculateHeight(for: element)
            let point = calculatePoint(for: element)
            element.view.frame = CGRect(x: point.x, y: point.y, width: width, height: height)
        }
    }
    
    
    private func configure() {
        addSubviews( elements.map{ $0.view })
    }
    
    private func reconfigure() {
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func calculateWidth(for element: BoxElement) -> CGFloat {
        switch element.width {
        case .copy:
            return element.view.frame.width
        case .fixed(size: let size):
            return size
        case ._relative(let multiplier, let relativeSide):
            let sizeOfSide = (relativeSide == .boxCurrentSide) ? frame.width : frame.height
            return sizeOfSide * multiplier
        }
    }
    
    private func calculateHeight(for element: BoxElement) -> CGFloat {
        switch element.heigth {
        case .copy:
            return element.view.frame.height
        case .fixed(size: let size):
            return size
        case ._relative(let multiplier, let relativeSide):
            let sizeOfSide = (relativeSide == .boxCurrentSide) ? frame.height : frame.width
            return sizeOfSide * multiplier
        }
    }
    
    private func calculatePoint(for element: BoxElement) -> CGPoint{
        let startX: CGFloat = 0
        let centerX: CGFloat = (frame.width / 2) - (element.view.frame.width / 2)
        let endX: CGFloat = frame.width - element.view.frame.width
        
        let startY: CGFloat = 0
        let centerY: CGFloat = (frame.height / 2) - (element.view.frame.height / 2)
        let endY: CGFloat = frame.height - element.view.frame.height
        
        switch element.alignment ?? alignment {
        case .topStart:
            return CGPoint(x: startX, y: startY)
        case .topCenter:
            return CGPoint(x: centerX, y: startY)
        case .topEnd:
            return CGPoint(x: endX, y: startY)
            
        case .middleStart:
            return CGPoint(x: startX, y: centerY)
        case .middleCenter:
            return CGPoint(x: centerX, y: centerY)
        case .middleEnd:
            return CGPoint(x: endX, y: centerY)
            
        case .bottomStart:
            return CGPoint(x: startX, y: endY)
        case .bottomCenter:
            return CGPoint(x: centerX, y: endY)
        case .bottomEnd:
            return CGPoint(x: endX, y: endY)
        }
    }
}
