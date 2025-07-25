//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation

public extension CGPoint {
    
    func getMainCoordinate(for direction: StackDirection) -> CGFloat {
        return (direction == .horizontal) ? x : y
    }
    
    func getCrossCoordinate(for direction: StackDirection) -> CGFloat {
        return (direction == .horizontal) ? y : x
    }
}
