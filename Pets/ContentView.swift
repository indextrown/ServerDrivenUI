//
//  ContentView.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import SwiftUI

struct ContentView: View {
    
    let service = WebService()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let result = try await service.load(resource: Constants.Urls.petListing)
                print(result)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
