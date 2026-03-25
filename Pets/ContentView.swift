//
//  ContentView.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = PetListViewModel(servicce: WebService())

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.components, id: \.id) { component in
                    component.render()
                }
                .navigationTitle("Pets")
            }
            .task {
                await vm.load()
            }
        }
    }
}

#Preview {
    ContentView()
}
