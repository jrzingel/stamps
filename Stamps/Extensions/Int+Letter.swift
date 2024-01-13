//
//  Int+Letter.swift
//  Stamps
//
//  Created by James Zingel on 14/01/24.
//

import Foundation

public extension Int {
    
    func toLetter() -> String {
        let a = Int(Unicode.Scalar("a").value)
        return "\(Unicode.Scalar(a + (self % 26)) ?? Unicode.Scalar("a"))"
    }
}
