//
//  HistoryTimelineView.swift
//  Beauty of the Ride
//
//  Created by iain on 08/06/2025.
//

import SwiftUI

struct HistoryTimelineView: View {
    @Binding var selectedRange: HistoryRange
    
    var body: some View {
        HStack(spacing: 4) {
            Button("Day") {
                print("day")
                selectedRange = .day
            }
            .font(.caption)
            .buttonStyle(.bordered)
            
            Button("Week") {
                selectedRange = .week
            }
            .font(.caption)
            .buttonStyle(.bordered)
            
            Button("Month") {
                selectedRange = .month
            }
            .font(.caption)
            .buttonStyle(.bordered)
            
            Button("Quarter") {
                selectedRange = .quarter
            }
            .font(.caption)
            .buttonStyle(.bordered)
            
            Button("Year") {
                selectedRange = .year
            }
            .font(.caption)
            .buttonStyle(.bordered)
            
            Button("All") {
                selectedRange = .all
            }
            .font(.caption)
            .buttonStyle(.bordered)
        }
        .accessibilityElement()
        .accessibilityAddTraits(.isTabBar)
    }
}

#Preview {
    HistoryTimelineView(selectedRange: .constant(.all))
}
