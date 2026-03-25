//
//  Navigator.swift
//  Pets
//
//  Created by 김동현 on 3/25/26.
//

import SwiftUI


/// content를 탭하면 destinationView를 sheet로 띄우는 공통 컴포넌트
/**
 SheetView(
     content: {
         Text("열기")
     },
     destinationView: AnyView(Text("Sheet 화면"))
 )
 */
struct SheetView<V: View>: View {
    @State private var isPresented: Bool = false
    let content: () -> V          /// View를 직접 받는 게 아니라 클로저로 받음
    let destinationView: AnyView  /// sheet에 띄울 View
    
    var body: some View {
        content().onTapGesture {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            destinationView
        }
    }
}

final class Navigator {
    
    /// Action 정보를 기반으로 화면 이동을 수행하는 라우팅 메서드
    ///
    /// - Parameters:
    ///   - action: 이동할 목적지(`destination`)와 이동 방식(`type`)을 포함한 정보
    ///   - content: 사용자가 탭할 트리거 View (예: 버튼, 셀 등)
    ///
    /// - Returns:
    ///   content를 감싸고, action에 따라 정의된 destination으로 이동하도록 구성된 View
    ///   (현재는 sheet 방식으로 감싸진 AnyView 반환)
    ///
    /// - Note:
    ///   - destination은 내부에서 enum 기반으로 결정됨
    ///   - 이동 방식(sheet, push 등)에 따라 wrapping View가 달라질 수 있음
    ///   - 반환 타입을 AnyView로 통일하여 다양한 View를 하나의 타입으로 처리
    static func perform<V: View>(
        action: Action,
        payload: Any? = nil,
        content: @escaping () -> V
    ) -> AnyView {
        var destinationView: AnyView!
        
        switch action.destination {
        case .petDetail:
            if let payload = payload as? CarouselRowUIModel {
                destinationView = PetDetailScreen(petId: payload.petId).toAnyView()
            } else {
                destinationView = EmptyView().toAnyView()
            }
            // destinationView = Text("Pet Detail").toAnyView()
        }
        
        switch action.type {
        case .sheet:
            return SheetView(content: {
                content()
            }, destinationView: destinationView).toAnyView()
        }
    }
}
