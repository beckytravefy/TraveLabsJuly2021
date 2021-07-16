//
//  TraveFutureApp.swift
//  Shared
//
//  Created by Becky Henderson on 7/8/21.
//

import SwiftUI

/*

Todo:
 General
    Real network request with async/await, task for view

 Contact View:
    Spacing above list/form on contact views
 Contacts View:
    Searching
    Sorting

 */

@main
struct TraveFutureApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
