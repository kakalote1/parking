//
//  CqParkingApp.swift
//  CqParking
//
//  Created by 王思远 on 2021/5/10.
//

import SwiftUI

@main
struct CqParkingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
