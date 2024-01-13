//
//  NavigationStore.swift
//  Outline
//
//  Created by James Zingel on 19/12/23.
//

import SwiftUI

// Controls app navigation

// Eventually implement URL link logic like https://swiftwithmajid.com/2022/10/05/mastering-navigationstack-in-swiftui-navigationpath/

@MainActor final class NavigationStore: ObservableObject {
    @Published var path = NavigationPath()
}
