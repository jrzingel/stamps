//
//  Result+Success.swift
//  Outline
//
//  Created by James on 9/12/23.
//

import Foundation

// Allow `.success` with no return value
public extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}
