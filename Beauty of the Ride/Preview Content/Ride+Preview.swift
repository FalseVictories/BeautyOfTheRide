import Foundation

@MainActor
extension Ride {
    static let preview: Ride = .init(date: .now,
                                     topSpeed: 10,
                                     averageSpeed: 6,
                                     currentSpeed: 3,
                                     totalDistance: 3870,
                                     totalDuration: 1984)
}
