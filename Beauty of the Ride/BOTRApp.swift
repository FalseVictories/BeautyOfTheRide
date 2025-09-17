//
//  Beauty_of_the_RideApp.swift
//  Beauty of the Ride
//
//  Created by iain on 02/06/2025.
//

import MapKit
import SwiftUI
import SwiftData

enum LocationAuthorizationStatus {
    case unknown
    case authorized
    case notAccurate
    case notAuthorized(String)
    
    var isAuthorized: Bool {
        switch self {
        case .authorized, .unknown:
            return true
        default:
            return false
        }
    }
}

@Observable
@MainActor
class BotRController {
    @ObservationIgnored
    let locationManager: CLLocationManager
    
    @ObservationIgnored
    var backgroundUpdates: CLBackgroundActivitySession?
    
    @ObservationIgnored
    var currentRide: Ride?
    var lastRide: Ride?
    
    var trackingRide: Bool = false
    
    var authorizationStatus: LocationAuthorizationStatus = .unknown
    
    init() {
        locationManager = CLLocationManager()
    }
    
    func startTracking() {
        trackingRide = true
        let currentRide = Ride(date: .now)
        self.currentRide = currentRide
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        backgroundUpdates = CLBackgroundActivitySession()
        Task {
            let stream = CLLocationUpdate.liveUpdates(.fitness)
            var lastLocation: CLLocation?
            
            for try await update in stream {
                if let location = update.location {
                    let distance = lastLocation != nil ? location.distance(from: lastLocation!) : 0
                    let newLocation = Location(timestamp: location.timestamp,
                                               coordinate: location.coordinate,
                                               altitude: location.altitude,
                                               speed: location.speed,
                                               distance: distance)

                    currentRide.addLocation(newLocation)
                    lastLocation = location
                } else if update.authorizationDeniedGlobally {
                    authorizationStatus = .notAuthorized("Please enable Location Services by going to Settings -> Privacy & Security")
                    trackingRide = false
                } else if update.authorizationDenied {
                    authorizationStatus = .notAuthorized("Please authorize LiveUpdaterSampleApp to access Location Services")
                    trackingRide = false
                } else if update.authorizationRestricted {
                    authorizationStatus = .notAuthorized("LiveUpdaterSampleApp can't access your location. Do you have Parental Controls enabled?")
                    trackingRide = false
                } else if update.accuracyLimited {
                    authorizationStatus = .notAccurate
                    trackingRide = false
                }
                
                if !trackingRide {
                    break
                }
            }
        }
    }
    
    func stopTracking() -> Ride? {
        trackingRide = false
        backgroundUpdates?.invalidate()
        backgroundUpdates = nil
        
        let ride = currentRide
        lastRide = currentRide
        currentRide = nil
        
        return ride
    }
}

@main
struct BOTRApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RideItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    @State var controller: BotRController = BotRController()

    var body: some Scene {
        WindowGroup {
            ContentView(currentRide: controller.currentRide ?? controller.lastRide,
                        isTrackingRide: controller.trackingRide,
                        startTrackingRide: { controller.startTracking() },
                        stopTrackingRide: { controller.stopTracking() },
                        locationAuthStatus: controller.authorizationStatus)
        }
        .modelContainer(sharedModelContainer)
        .environment(controller)
    }
}
