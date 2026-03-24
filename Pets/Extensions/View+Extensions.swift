//
//  View+Extensions.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
