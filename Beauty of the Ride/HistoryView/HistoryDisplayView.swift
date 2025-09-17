import SwiftData
import SwiftUI

struct Results {
    static let empty = Self(
        totalDistance: .init(value: 0, unit: .meters),
        topSpeed: .init(value: 0, unit: .metersPerSecond),
        averageSpeed: .init(value: 0, unit: .metersPerSecond),
        totalDuration: .seconds(0),
        averageDuration: .seconds(0))
        
    let totalDistance: Measurement<UnitLength>
    let topSpeed: Measurement<UnitSpeed>
    let averageSpeed: Measurement<UnitSpeed>
    
    let totalDuration: Duration
    let averageDuration: Duration
}

struct HistoryDisplayView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var rides: [RideItem] = []
//    @Query private var invertedRides: [RideItem] = []
    
    let range: HistoryRange
    var results: Results {
        print("GEnerating results")
        return updateResults()
    }
    
    init(range: HistoryRange) {
        print("init: \(range)")
        _rides = .init(filter: range.filter())
//        _invertedRides = .init(filter: range.previousFilter())
        
        self.range = range
    }
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            let _ = print("Updating results")
            let localResults = results
            
            VStack(alignment: .leading) {
                Text("Distance: \(localResults.totalDistance, format: lengthStyle)")
                Text("Top Speed: \(localResults.topSpeed, format: speedStyle)")
                Text("Average Speed: \(localResults.averageSpeed, format: speedStyle)")
                Text("Number of Rides: \(rides.count)")
            }
            
            VStack(alignment: .leading) {
                Text("Total Duration: \(localResults.totalDuration.formatted())")
                Text("Average Duration: \(localResults.averageDuration.formatted())")
            }
        }
        .font(.system(size: 11))
    }
}

extension HistoryDisplayView {
    func updateResults() -> Results {
        var totalDistance: Double = 0.0
        var topSpeed: Double = 0.0
        var averageSpeed: Double = 0.0
        var totalDuration: TimeInterval = 0
        
        print("Number of rides: \(rides.count)")
        for ride in rides {
            totalDistance += ride.totalDistance
            topSpeed = max(topSpeed, ride.topSpeed)
            averageSpeed = max(averageSpeed, ride.averageSpeed)
            totalDuration += ride.totalDuration
        }
        
        let averageDuration = rides.isEmpty ? 0 : totalDuration / Double(rides.count)
        
        return Results(totalDistance: .init(value: totalDistance,
                                            unit: .meters),
                       topSpeed: .init(value: topSpeed, unit: .metersPerSecond),
                       averageSpeed: .init(value: averageSpeed,
                                           unit: .metersPerSecond),
                       totalDuration: .seconds(totalDuration),
                       averageDuration: .seconds(averageDuration))
    }
}

#if DEBUG
#Preview {
    HistoryDisplayView(range: .all)
        .modelContainer(PreviewData.previewContainer)
}
#endif
