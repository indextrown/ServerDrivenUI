//
//  UIComponrnt.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

/*
 https://babbab2.tistory.com/175
 https://zeddios.tistory.com/255
 */
import Foundation
import SwiftUI

protocol UIComponent {
    var uniqueId: String { get }
    func render() -> AnyView
}


