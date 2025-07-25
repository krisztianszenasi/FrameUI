//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


public extension CGRect {
    
    func getMainSize(for direction: StackDirection) -> CGFloat {
        return size.getMainSize(for: direction)
    }
    
    func getCrossSize(for direction: StackDirection) -> CGFloat {
        return size.getCrossSize(for: direction)
    }
    
    func getMainCoordinate(for direction: StackDirection) -> CGFloat {
        return origin.getMainCoordinate(for: direction)
    }
    
    func getCrossCoordinate(for direction: StackDirection) -> CGFloat {
        return origin.getCrossCoordinate(for: direction)
    }
    
    static func makeHorizontally(mc: CGFloat, cc: CGFloat, ms: CGFloat, cs: CGFloat) -> CGRect {
        return CGRect(x: mc, y: cc, width: ms, height: cs)
    }
    
    static func makeVertically(mc: CGFloat, cc: CGFloat, ms: CGFloat, cs: CGFloat) -> CGRect {
        return CGRect(x: cc, y: mc, width: cs, height: ms)
    }
}
