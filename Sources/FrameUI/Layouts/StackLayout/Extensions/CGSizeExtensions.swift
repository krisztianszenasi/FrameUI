//
//  File.swift
//  FrameUI
//
//  Created by Krisztián Szénási on 2025. 07. 25..
//

import Foundation


public extension CGSize {
    
    func getMainSize(for direction: StackDirection) -> CGFloat {
        return (direction == .horizontal) ? width : height
    }
        
    func getCrossSize(for direction: StackDirection) -> CGFloat {
        return (direction == .horizontal) ? height : width
    }
}
