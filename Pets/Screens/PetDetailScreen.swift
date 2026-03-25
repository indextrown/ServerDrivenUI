//
//  PetDetailScreen.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import SwiftUI

struct PetDetailScreen: View {
    
    @StateObject private var vm: PetDetailViewModel
    
    init(petId: Int) {
        _vm = StateObject(wrappedValue: PetDetailViewModel(service: WebService()))
        self.petId = petId
    }
    
    let petId: Int
    
    var body: some View {
        ScrollView {
            ForEach(vm.components, id: \.id) { component in
                component.render()
            }
        }
        .task {
            await vm.load(petId: petId)
        }
    }
}

#Preview {
    PetDetailScreen(petId: 2)
}
