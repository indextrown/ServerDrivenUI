//
//  Action.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import Foundation

enum ActionType: String, Decodable {
    case sheet
}

struct Action: Decodable {
    let type: ActionType
    let destination: Route
}
