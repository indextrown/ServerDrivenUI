//
//  RatingRowComponent.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import SwiftUI

struct RatingRowComponent: UIComponent {
    let id = UUID()
    let uiModel: RatingRowUIModel
    
    func render() -> AnyView {
        RatingView(rating: .constant(uiModel.rating)).toAnyView()
    }
}
