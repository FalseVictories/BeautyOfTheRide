import SwiftUI

struct SpeedView: View {
    let highestSpeed: Measurement<UnitSpeed>
    let currentSpeed: Measurement<UnitSpeed>
    let topSpeed: Measurement<UnitSpeed>
    let averageSpeed: Measurement<UnitSpeed>
    
    var body: some View {
        VStack(alignment: .leading) {
            SpeedBar(title: "Top Speed",
                     speed: topSpeed,
                     color: .topSpeed,
                     width: width(for: topSpeed))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            SpeedBar(title: "Average Speed",
                     speed: averageSpeed,
                     color: .averageSpeed,
                     width: width(for: averageSpeed))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            SpeedBar(title: "Current Speed",
                     speed: currentSpeed,
                     color: .currentSpeed,
                     width: width(for: currentSpeed))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .border(.green, width: 2)
        .frame(width: 300)
    }
}

extension SpeedView {
    func width(for speed: Measurement<UnitSpeed>) -> CGFloat {
        if (speed.value <= 0) {
            return 0
        }
        
        let ratio = highestSpeed.value / speed.value
        print("high: \(highestSpeed) | speed: \(speed)")
        print("   \(ratio)- \(300 / ratio)")
        return 300 * ratio
    }
}

struct SpeedBar: View {
    let title: String
    let speed: Measurement<UnitSpeed>
    let color: Color
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.foreground)
                .accessibilityAddTraits(.isHeader)
            
            ZStack(alignment: .leading) {
                UnevenRoundedRectangle(cornerRadii: .init( bottomTrailing: 20, topTrailing: 20))
                    .fill(color)
                    .frame(width: width, height: 30)
                
                Text("\(speed, format: speedStyle)")
                    .padding(.leading)
                    .font(.headline)
                    .bold(true)
            }
            .shadow(radius: 6)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SpeedView(highestSpeed: Measurement(value: 10,
                                        unit: .metersPerSecond),
              currentSpeed: Measurement(value: 5,
                                        unit: .metersPerSecond),
              topSpeed: Measurement(value: 8,
                                    unit: .metersPerSecond),
              averageSpeed: Measurement(value: 7,
                                        unit: .metersPerSecond))
}
