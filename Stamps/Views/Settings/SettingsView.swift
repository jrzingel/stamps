//
//  SettingsView.swift
//  Stamps
//
//  Created by James Zingel on 24/01/24.
//

import SwiftUI

struct SettingsView: View {
    @State var apiUrl = "https://api.example.com"
    
    
    var body: some View {
        List {
            Section("Api Settings") {
                Text("API server (optional)")
                TextField("API server host", text: $apiUrl)
                    .keyboardType(.URL)
                    .textContentType(.URL)
                    .foregroundStyle(.link)
                .onSubmit {
                    print("Current url of \(apiUrl)")
                }
                
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
