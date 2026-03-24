//
//  FeatureImageComponent.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import SwiftUI

struct FeatureImageComponent: UIComponent {
    
    let uiModel: FeatureImageUIModel
    
    var uniqueId: String {
        return ComponentType.featuredImage.rawValue
    }
    
    func render() -> AnyView {
        AsyncImage(url: uiModel.imageUrl) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }.toAnyView()
    }
}
