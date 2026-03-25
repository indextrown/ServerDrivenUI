//
//  TextRowComponent.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import SwiftUI

struct TextRowComponent: UIComponent {
    
    var id = UUID()
    
    let uiModel: TextRowUIModel
    
    func render() -> AnyView {
        Text(uiModel.text)
            .padding()
            .toAnyView()
    }
    
}
