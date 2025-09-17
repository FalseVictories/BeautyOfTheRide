import CoreLocation
import SwiftUI
import SwiftData

private struct RideData {
    static let empty: RideData = .init(highestSpeed: 0, currentSpeed: 0,
                                       averageSpeed: 0, topSpeed: 0,
                                       totalDistance: 0,
                                       duration: .seconds(0))
    
    let highestSpeed: Measurement<UnitSpeed>
    let currentSpeed: Measurement<UnitSpeed>
    let averageSpeed: Measurement<UnitSpeed>
    let topSpeed: Measurement<UnitSpeed>
    let totalDistance: Measurement<UnitLength>
    let duration: Duration
    
    init(highestSpeed: CLLocationSpeed,
         currentSpeed: CLLocationSpeed,
         averageSpeed: CLLocationSpeed,
         topSpeed: CLLocationSpeed,
         totalDistance: CLLocationDistance,
         duration: Duration) {
        self.highestSpeed = .init(value: highestSpeed, unit: .metersPerSecond)
        self.currentSpeed = .init(value: currentSpeed, unit: .metersPerSecond)
        self.averageSpeed = .init(value: averageSpeed, unit: .metersPerSecond)
        self.topSpeed = .init(value: topSpeed, unit: .metersPerSecond)
        self.totalDistance = .init(value: totalDistance, unit: .meters)
        self.duration = duration
    }
}

struct ContentView: View {
    private static let historySection = "history"
    private static let rideSection = "ride"
    private static let errorSection = "error"
    
    @Environment(\.modelContext) private var modelContext
    @State var highestSpeed: Double = 20
    
    let currentRide: Ride?
    let isTrackingRide: Bool
    let startTrackingRide: () -> Void
    let stopTrackingRide: () -> Ride?
    
    let locationAuthStatus: LocationAuthorizationStatus
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                HistoryView()
                    .id(ContentView.historySection)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityHeading(.h2)
                
                if locationAuthStatus.isAuthorized {
                    let rideData = rideData(fromRide: currentRide)
                    
                    RideView(highestSpeed: rideData.highestSpeed,
                             currentSpeed: rideData.currentSpeed,
                             averageSpeed: rideData.averageSpeed,
                             topSpeed: rideData.topSpeed,
                             totalDistance: rideData.totalDistance,
                             totalDuration: rideData.duration)
                    .id(ContentView.rideSection)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityHeading(.h1)
                } else {
                    ErrorView(errorReason: locationAuthStatus)
                        .id(ContentView.errorSection)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityHeading(.h1)
                }
                
                Spacer()
                
                /*
#if DEBUG
                HStack {
                    Button(action: {
                        PreviewData.createDevData(inContext: modelContext)
                    }, label: {
                        Text("Load test data")
                    })
                    
                    Button(action: {
                        do {
                            try modelContext.delete(model: RideItem.self)
                        } catch {
                            print("Error: \(error)")
                        }
                    }, label: {
                        Text("Clear data")
                    })
                }
#endif // DEBUG
                 */
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        startOrStopRide()
                    } label: {
                        HStack {
                            Text(isTrackingRide ? "Stop Ride" : "Start Ride")
                            Image(systemName: "bicycle")
                        }
                        .padding()
                    }
                    .tint(isTrackingRide ? Color.topSpeed : Color.currentSpeed)
                }
            }
        }
    }
}

extension ContentView {
    private func rideData(fromRide ride: Ride?) -> RideData {
        if let ride = ride {
            return RideData(highestSpeed: highestSpeed,
                            currentSpeed: ride.currentSpeed,
                            averageSpeed: ride.averageSpeed,
                            topSpeed: ride.topSpeed, totalDistance: ride.totalDistance,
                            duration: .seconds(ride.totalDuration))
        } else {
            return .empty
        }
    }
    
    private func startOrStopRide() {
        if isTrackingRide {
            if let ride = stopTrackingRide() {
                modelContext.insert(ride.itemFromRide())
                do {
                    try modelContext.save()
                } catch {
                    print("Error: \(error)")
                }
            }
        } else {
            startTrackingRide()
        }
    }
}

#if DEBUG
#Preview("No Ride"){
    ContentView(currentRide: nil,
                isTrackingRide: false,
                startTrackingRide: {},
                stopTrackingRide: { nil },
                locationAuthStatus: .authorized)
    .modelContainer(for: RideItem.self, inMemory: true)
}

#Preview("Ride") {
    ContentView(currentRide: .preview,
                isTrackingRide: true,
                startTrackingRide: {},
                stopTrackingRide: { nil },
                locationAuthStatus: .notAccurate)
    .modelContainer(for: RideItem.self, inMemory: true)
}
#endif
