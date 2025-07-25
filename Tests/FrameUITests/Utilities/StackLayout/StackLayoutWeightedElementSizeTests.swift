//
//  StackLayoutElementSizeTests.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import XCTest
@testable import FrameUI

@MainActor
final class StackLayoutElementSizeTests: XCTestCase {
    
    func testLayoutStackedSubviews_WithEqualMainWeightSizeHorizontally_DistributesEqually() {
        let parentWidth: CGFloat = 12
        let subviews = [UIView(), UIView(), UIView()]
        

        StackLayout.layoutStackedSubviews(
            elements: subviews.map{ StackElement(view: $0, mainSize: .weighted(size: 1)) },
            in: UIView(frame: CGRect(x: 0, y: 0, width: parentWidth, height: 0)),
            direction: .horizontal
        )
        
        
        for (idx, subview) in subviews.enumerated() {
            let expectedWidth = parentWidth / CGFloat(subviews.count)
            XCTAssertEqual(subview.frame.size.width, expectedWidth)
            XCTAssertEqual(subview.frame.origin.x, expectedWidth * CGFloat(idx))
        }
    }
    
    func testLayoutStackedSubviews_WithEqualMainWeightSizeVertically_DistributesEqually() {
        let parentHeight: CGFloat = 12
        let subviews = [UIView(), UIView(), UIView()]
        

        StackLayout.layoutStackedSubviews(
            elements: subviews.map{ StackElement(view: $0, mainSize: .weighted(size: 1)) },
            in: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: parentHeight)),
            direction: .vertical
        )
        
        
        for (idx, subview) in subviews.enumerated() {
            let expectedHeight = parentHeight / CGFloat(subviews.count)
            XCTAssertEqual(subview.frame.size.height, expectedHeight)
            XCTAssertEqual(subview.frame.origin.y, expectedHeight * CGFloat(idx))
        }
    }
    
    func testLayoutStackedSubviews_WithUnequalMainWeightSizeHorizontally_DistributesProportionally() {
        let parentWidth: CGFloat = 12
        let stackedElements = [
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 2)
            ),
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 4)
            ),
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 6)
            )
        ]
        

        StackLayout.layoutStackedSubviews(
            elements: stackedElements,
            in: UIView(frame: CGRect(x: 0, y: 0, width: parentWidth, height: 0)),
            direction: .horizontal
        )
        
        
        var prevExpectedXCoordinate: CGFloat = 0
        for element in stackedElements {
            guard case let .weighted(expectedSize) = element.mainSize else { return }
            XCTAssertEqual(element.view.frame.size.width, expectedSize)
            XCTAssertEqual(element.view.frame.origin.x, prevExpectedXCoordinate)
            prevExpectedXCoordinate += expectedSize
        }
    }
    
    func testLayoutStackedSubviews_WithUnequalMainWeightSizeVertically_DistributesProportionally() {
        let parentHeight: CGFloat = 12
        let stackedElements = [
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 2)
            ),
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 4)
            ),
            StackElement(
                view: UIView(),
                mainSize: .weighted(size: 6)
            )
        ]
        

        StackLayout.layoutStackedSubviews(
            elements: stackedElements,
            in: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: parentHeight)),
            direction: .vertical
        )
        
        
        var prevExpectedYCoordinate: CGFloat = 0
        for element in stackedElements {
            guard case let .weighted(expectedSize) = element.mainSize else { return }
            XCTAssertEqual(element.view.frame.size.height, expectedSize)
            XCTAssertEqual(element.view.frame.origin.y, prevExpectedYCoordinate)
            prevExpectedYCoordinate += expectedSize
        }
    }
}
