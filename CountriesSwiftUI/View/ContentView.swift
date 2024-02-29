//
//  ContentView.swift
//  CountriesSwiftUI
//
//  Created by Andrii Hamula on 14.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .scaledToFill()
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.title3)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
