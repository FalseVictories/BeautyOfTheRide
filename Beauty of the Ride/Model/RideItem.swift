import CoreLocation
import Foundation
import SwiftData

@Model
final class RideItem {
    var date: Date
    
    var topSpeed: CLLocationSpeed = 0
    var averageSpeed: CLLocationSpeed = 0
    
    var totalDistance: CLLocationDistance = 0
    var totalDuration: TimeInterval = 0
    
    init(date: Date,
         topSpeed: CLLocationSpeed,
         averageSpeed: CLLocationSpeed,
         totalDistance: CLLocationDistance,
         totalDuration: TimeInterval) {
        self.date = date
        self.topSpeed = topSpeed
        self.averageSpeed = averageSpeed
        self.totalDistance = totalDistance
        self.totalDuration = totalDuration
    }
}
