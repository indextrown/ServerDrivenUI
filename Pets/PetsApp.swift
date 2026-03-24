//
//  PetsApp.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import SwiftUI

@main
struct PetsApp: App {
    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
            ContentView()
        }
    }
}
