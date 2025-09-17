import Foundation
import CoreLocation
import SwiftData

struct Coordinate : Codable {
    var latitude: Double
    var longitude: Double
    
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude,
                                      longitude: self.longitude)
    }
}

final class Location : Codable {
    var timestamp: Date
    var coordinate: Coordinate
    var altitude: CLLocationDistance
    var speed: CLLocationSpeed
    var distance: CLLocationDistance = 0
    
    private enum CodingKeys: String, CodingKey {
        case timestamp
        case latitude
        case longitude
        case altitude
        case speed
        case distance
    }
    
    init(timestamp: Date,
         coordinate: CLLocationCoordinate2D,
         altitude: CLLocationDistance,
         speed: CLLocationSpeed,
         distance: CLLocationDistance) {
        self.timestamp = timestamp
        self.coordinate = Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.altitude = altitude
        self.speed = speed
        self.distance = distance
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        
        let latitude = try values.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try values.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = Coordinate(latitude: latitude, longitude: longitude)
        
        altitude = try values.decode(CLLocationDistance.self, forKey: .altitude)
        speed = try values.decode(CLLocationSpeed.self, forKey: .speed)
        distance = try values.decode(CLLocationDistance.self, forKey: .distance)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(speed, forKey: .speed)
        try container.encode(distance, forKey: .distance)
    }
}
