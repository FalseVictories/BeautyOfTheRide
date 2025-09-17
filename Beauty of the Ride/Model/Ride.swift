import Foundation
import CoreLocation
import SwiftData

@Observable
final class Ride {
    var date: Date
    var locationCount: Int = 0
    
    var topSpeed: CLLocationSpeed = 0
    var averageSpeed: CLLocationSpeed = 0
    var currentSpeed: CLLocationSpeed = 0
    
    var totalDistance: CLLocationDistance = 0
    var totalDuration: TimeInterval = 0

    private var totalSpeed: CLLocationSpeed = 0
    private var startTime: TimeInterval?
    
    init(date: Date) {
        self.date = date
    }
    
    init(date: Date,
         topSpeed: CLLocationSpeed,
         averageSpeed: CLLocationSpeed,
         currentSpeed: CLLocationSpeed,
         totalDistance: CLLocationDistance,
         totalDuration: TimeInterval) {
        self.date = date
        self.topSpeed = topSpeed
        self.averageSpeed = averageSpeed
        self.totalDistance = totalDistance
        self.totalDuration = totalDuration
    }
}
 
extension Ride {
    func addLocation(_ location: Location) {
        currentSpeed = location.speed

        if startTime == nil {
            startTime = location.timestamp.timeIntervalSince1970
        }
        
        if location.speed <= 0 {
            return
        }

        guard let startTime else {
            return
        }
        
        totalSpeed += location.speed
        averageSpeed = totalSpeed / Double(locationCount + 1)
        topSpeed = max(topSpeed, location.speed)
        
        totalDistance += location.distance
        
        totalDuration = location.timestamp.timeIntervalSince1970 - startTime
        locationCount += 1
    }
    
    func itemFromRide() -> RideItem {
        RideItem(date: date,
                 topSpeed: topSpeed,
                 averageSpeed: averageSpeed,
                 totalDistance: totalDistance,
                 totalDuration: totalDuration)
    }
}
