//
//  lungs_firstApp.swift
//  lungs-first
//
//  Created by Marius Glup on 05.05.26.
//

import SwiftUI
import SwiftData

@main
struct lungs_firstApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            Challenge.self,
            UserChallenge.self,
            LogEntry.self,
            DailyCheckIn.self,
            Badge.self,
            UserSettings.self,
        ])
        do {
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
            let context = ModelContext(container)
            SeedData.seedIfNeeded(context: context)
            #if DEBUG
            DevSeeder.applyIfNeeded(context: context)
            #endif
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
