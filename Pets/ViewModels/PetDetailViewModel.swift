//
//  PetDetailViewModel.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import Foundation

@MainActor
final class PetDetailViewModel: ObservableObject {
    private var service: NetworkService
    @Published var components: [UIComponent] = []
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func load(petId: Int) async {
        do {
            let screenModel = try await service.load(Constants.ScreenResources.petDetail(petId: petId))
            self.components = try screenModel.buildComponents()
        } catch {
            print(error)
        }
    }
}
