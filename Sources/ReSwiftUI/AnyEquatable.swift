//
//  File.swift
//  
//
//  Created by KUOCHUNLIN on 2024/6/28.
//

import Foundation

public extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        return self == other
    }
    func isExactlyEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}


public func ==<L, R>(lhs: L, rhs: R) -> Bool {
    guard
        let equatableLhs = lhs as? any Equatable,
        let equatableRhs = rhs as? any Equatable
    else { return false }
    
    return equatableLhs.isEqual(equatableRhs)
}
