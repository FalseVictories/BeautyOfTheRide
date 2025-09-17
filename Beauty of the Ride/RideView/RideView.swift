import SwiftUI

struct RideView: View {
    let highestSpeed: Measurement<UnitSpeed>
    let currentSpeed: Measurement<UnitSpeed>
    let averageSpeed: Measurement<UnitSpeed>
    let topSpeed: Measurement<UnitSpeed>
    let totalDistance: Measurement<UnitLength>
    let totalDuration: Duration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(totalDistance, format: lengthStyle)")
                .foregroundStyle(.primary)
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(totalDuration.formatted())
                .foregroundStyle(.secondary)
            
            Divider()
            
            SpeedView(highestSpeed: highestSpeed,
                      currentSpeed: currentSpeed,
                      topSpeed: topSpeed,
                      averageSpeed: averageSpeed)
            .frame(alignment: .leading)
        }
        .frame(width: 300)
        .padding(30)
        .outlinedBox()
        .accessibilityElement()
        .accessibilityLabel("Speed")
    }
}

#Preview {
    RideView(highestSpeed: Measurement(value: 3,
                                       unit: .metersPerSecond),
             currentSpeed: Measurement(value: 5.5,
                                       unit: .metersPerSecond),
             averageSpeed: Measurement(value: 3.2,
                                       unit: .metersPerSecond),
             topSpeed: Measurement(value: 8.6,
                                   unit: .metersPerSecond),
             totalDistance: Measurement(value: 10000,
                                        unit: .meters),
             totalDuration: .seconds(799))
}
