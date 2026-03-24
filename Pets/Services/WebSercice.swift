//
//  WebSercice.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidServerResponse
}

class WebService {
    func load(resource: String) async throws -> ScreenModel {
        
        guard let url = URL(string: resource) else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        
        return try JSONDecoder().decode(ScreenModel.self, from: data)
    }
}
 
