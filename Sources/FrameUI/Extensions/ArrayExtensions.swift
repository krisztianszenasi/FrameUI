//
//  ArrayExtensions.swift
//  IconCraft
//
//  Created by Krisztián Szénási on 2025. 07. 22..
//

import Foundation


extension Array {
    
    /// Inserts the new element between every existing element.
    ///
    /// Example: `[1,1].insertBetween(2)`
    /// Result: `[1,2,1]`
    func insertBetween(_ createNewElement: () -> Element) -> [Element] {
        guard !isEmpty else { return [] }
        return self.enumerated().flatMap { index, element in
            index < self.count - 1 ? [element, createNewElement()] : [element]
        }
    }
    
    /// Inserts the new element around every existing element.
    ///
    /// Example: `[1,1].insertAround(2)`
    /// Result: `[2,1,2,2,1,2]`
    func insertArround(_ createNewElement: () -> Element) -> [Element] {
        guard !isEmpty else { return [] }
        return flatMap { [createNewElement(), $0, createNewElement()] }
    }
    
    /// Inserts the new element around every existing element.
    ///
    /// Example: `[1,1].insertEvenly(2)`
    /// Result: `[2,1,2,1,2]`
    func insertEvenly(_ createNewElement: () -> Element) -> [Element] {
        isEmpty ? [] : flatMap { [createNewElement(), $0] } + [createNewElement()]
    }
}
