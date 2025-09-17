import Foundation

let speedStyle: Measurement<UnitSpeed>.FormatStyle =
    .measurement(width: .abbreviated,
                 usage: .general,
                 numberFormatStyle: .number.precision(.fractionLength(0...1)))
let lengthStyle: Measurement<UnitLength>.FormatStyle =
    .measurement(width: .abbreviated,
                 usage: .road,
                 numberFormatStyle: .number.precision(.fractionLength(0...1)))
