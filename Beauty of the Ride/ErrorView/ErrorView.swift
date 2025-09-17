//
//  ErrorView.swift
//  Beauty of the Ride
//
//  Created by iain on 21/06/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorReason: LocationAuthorizationStatus
    
    var body: some View {
        switch errorReason {
        case .unknown:
            EmptyView()
            
        case .authorized:
            EmptyView()
            
        case .notAccurate:
            VStack(spacing: 8) {
                Text("The location accuracy is not precise enough to track your ride. Please enable 'Precise Location' in the Settings app.")

                Button("Open Settings") {
                    openSettings()
                }
                .accessibilityHint(Text("Open the Settings app to enable 'Precise Location'"))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.topSpeed))
            .foregroundStyle(.primary)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .shadow(radius: 10)
            .accessibilityElement(children: .combine)

        case .notAuthorized(let suggestion):
            Text(suggestion)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.topSpeed))
                .foregroundStyle(.primary)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .shadow(radius: 10)
                .accessibilityElement(children: .combine)
        }
    }
}

#Preview {
    Group {
        ErrorView(errorReason: .notAuthorized("Test reason"))
        ErrorView(errorReason: .notAccurate)
    }
}
