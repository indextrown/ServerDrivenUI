//
//  PetListViewModel.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

@MainActor
final class PetListViewModel: ObservableObject {
    private var servicce: NetworkService
    @Published var components: [UIComponent] = []
    
    init(servicce: NetworkService) {
        self.servicce = servicce
    }
    
    func load() async {
        do {
            let screenModel = try await servicce.load(Constants.ScreenResources.petListing)
            components = try screenModel.buildComponents()
            
        } catch {
            print(error)
        }
    }
}
