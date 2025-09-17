import SwiftData
import SwiftUI

struct HistoryView: View {
    @State var selectedRange: HistoryRange = .all
        
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HistoryTimelineView(selectedRange: $selectedRange)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 0, trailing: 8))
            HistoryDisplayView(range: selectedRange)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.averageSpeed))
        .foregroundStyle(.primary)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .shadow(radius: 10)
        .accessibilityElement()
        .accessibilityLabel("History")
    }
}

#if DEBUG
#Preview {
    HistoryView()
        .modelContainer(PreviewData.previewContainer)
}
#endif
