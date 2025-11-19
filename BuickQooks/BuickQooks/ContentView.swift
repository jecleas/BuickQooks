//
//  ContentView.swift
//  BuickQooks
//
//  Created by Franco  Buena on 19/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "book.fill")
                .resizable()
                .aspectRatio(contentMode: .fit) // Or .scaledToFit()
                .frame(width: 100, height: 100)
            Text("BUICK QOOKS")
                .font(Font.title.bold())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
