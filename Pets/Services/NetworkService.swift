//
//  NetworkService.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

protocol NetworkService {
    func load(_ resourceName: String) async throws -> ScreenModel
}
