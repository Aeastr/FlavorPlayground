//
//  FlavorPlaygroundApp.swift
//  FlavorPlayground
//
//  Created by Aether on 17/12/2024.
//

import SwiftUI

@main
struct FlavorPlaygroundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
