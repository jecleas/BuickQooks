//
//  ContentView.swift
//  BuickQooks
//
//  Created by Franco  Buena on 19/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int = 0

    private let headerColor = Color(.sRGB, red: 0.0, green: 0.30, blue: 0.20, opacity: 1.0)

    var body: some View {
        ZStack {
            // Whole screen background is white
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top header pane with dark green background and fixed height
                headerView

                // Rest of the content on white
                contentView
                    .padding(.horizontal)
                    .padding(.top, 24)

                Spacer(minLength: 24)
            }
        }
    }

    private var headerView: some View {
        ZStack {
            headerColor
                .ignoresSafeArea(edges: .top)

            HStack(alignment: .center, spacing: 12) {
                // Replace with a system symbol temporarily to verify visibility if needed
                Image("app")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)

                Text("BUICK QOOKS")
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal)
        }
        // Give the header a minimum height so it never collapses
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
    }

    private var contentView: some View {
        VStack(spacing: 16) {
            Text("\(count)")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
                .accessibilityLabel("Current count is \(count)")

            Button {
                count += 1
            } label: {
                Text("Start")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(headerColor.opacity(0.15))
                    .foregroundStyle(headerColor)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityHint("Increments the number below the title")
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    ContentView()
}
