import Foundation
import SwiftUI

let speedStyle: Measurement<UnitSpeed>.FormatStyle =
    .measurement(width: .abbreviated,
                 usage: .general,
                 numberFormatStyle: .number.precision(.fractionLength(0...1)))
let lengthStyle: Measurement<UnitLength>.FormatStyle =
    .measurement(width: .abbreviated,
                 usage: .road,
                 numberFormatStyle: .number.precision(.fractionLength(0...1)))

extension View {
    @ViewBuilder func outlinedBox() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.secondary, lineWidth: 0.25)
                .fill(Color.gray.opacity(0.125))
                .shadow(radius: 10)
        )
    }
}
