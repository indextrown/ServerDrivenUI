//
//  ScreenModel.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

enum ComponentError: Error {
    case decodingError
}

/// 서버가 내려주는 컴포넌트 종류 식별
enum ComponentType: String, Decodable {
    case featuredImage
    case carousel
}

/// 서버 Json의 개별 컴포넌트 원본 모델
struct ComponentModel: Decodable {
    let type: ComponentType
    // let data: [String: String]
    
    // 어떤 값이든 가능
    let data: [String: Any]
    
    // Json에서 꺼낼 key 정의
    private enum CodingKeys: CodingKey {
        case type
        case data
    }
    
    // JSON의 data를 일반 Decodable이 아니라 Any기반 딕셔너리로 직접 디코딩 하는 커스텀 초기화
    init(from decoder: any Decoder) throws {
        /// JSON을 딕셔너리처럼 접근 가능하게 만듦
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        /// type 디코딩으로 enum으로 전환
        self.type = try container.decode(ComponentType.self, forKey: .type)
        
        /// json -> Json -> dictionary
        self.data = try container.decode(Json.self, forKey: .data).value as! [String: Any]
    }
}

/// 페이지 단위 모델
struct ScreenModel: Decodable {
    let pageTitle: String
    let components: [ComponentModel]
}

extension ScreenModel {
    /// 컴포넌트를 순회하여 각 컴포넌트를 생성 후 배열 반환
    /// UIComponent: 모든 동적 컴포넌트가 따르는 공통 인터페이스
    func buildComponents() throws -> [UIComponent] {
        var components: [UIComponent] = []
        
        for component in self.components {
            switch component.type {
                
            case .featuredImage:
                guard let uiModel: FeatureImageUIModel = component.data.decode() else {
                    throw ComponentError.decodingError
                }
                components.append(FeatureImageComponent(uiModel: uiModel))
                
            case .carousel:
                guard let uiModel: CarouselUIModel = component.data.decode() else {
                    throw ComponentError.decodingError
                }
                
                components.append(CarouselComponent(uiModel: uiModel)) 
            }
        }
        return components
    }
}
