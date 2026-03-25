//
//  RatingView.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int?
    
    private func starType(index: Int) -> String {
        if let rating = self.rating {
            return index <= rating ? "star.fill" : "star"
        } else {
            return "star"
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundStyle(Color.orange)
            }
        }
    }
}

#Preview {
    RatingView(rating: Binding.constant(2))
}
