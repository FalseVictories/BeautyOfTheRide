import Foundation
import SwiftData

@MainActor
class PreviewData {
    private static func createRide(on date: Date) -> RideItem {
        RideItem(date: date,
                 topSpeed: .random(in: 1...10),
                 averageSpeed: .random(in: 1...10),
                 totalDistance: .random(in: 1000...10000),
                 totalDuration: .random(in: 600...7200))
    }
    
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: RideItem.self, configurations: config)

            container.mainContext.insert(createRide(on: .now))
            container.mainContext.insert(createRide(on: .now.addingTimeInterval(-60 * 60 * 24)))
            container.mainContext.insert(createRide(on: .now.addingTimeInterval(-60 * 60 * 24 * 7)))
            container.mainContext.insert(createRide(on: .now.addingTimeInterval(-60 * 60 * 24 * 30)))
            container.mainContext.insert(createRide(on: .now.addingTimeInterval(-60 * 60 * 24 * 90)))
            container.mainContext.insert(createRide(on: .now.addingTimeInterval(-60 * 60 * 24 * 365)))
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    static func createDevData(inContext context: ModelContext) {
        do {
            try context.delete(model: RideItem.self)
            context.insert(createRide(on: .now))
            
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            context.insert(createRide(on: yesterday))
            
            let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            context.insert(createRide(on: lastWeek))

            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
}
