//
//  JSON.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

enum DecodingError: Error {
    case dataCorruptedError
}

/// 어떤 JSON 구조든 `[String: Any]`, `[Any]`, 기본 타입(String, Int, Bool)으로
/// 변환하기 위한 커스텀 Decodable 타입
///
/// 핵심 역할:
/// - JSON 구조를 미리 정의하지 않고도 파싱 가능
/// - 내부적으로 재귀적으로 디코딩하여 Any 타입으로 변환
struct Json: Decodable {
    
    /// 최종 파싱 결과를 저장 (Dictionary / Array / Primitive 타입)
    var value: Any
    
    /// 동적인 key를 처리하기 위한 CodingKey 구현
    /// (JSON key를 문자열/숫자 모두 처리 가능)
    private struct CodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    /// 문자열 key 처리
    init(from decoder: any Decoder) throws {
        // 1. JSON이 Dictionary 형태인지 확인
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            
            // 모든 key를 순회하면서 재귀적으로 디코딩
            for key in container.allKeys {
                result[key.stringValue] = try container.decode(Json.self, forKey: key).value
            }
            value = result
        // 2. 단일 값 또는 배열 처리
        } else if let container = try? decoder.singleValueContainer() {
            if let stringValue = try? container.decode(String.self) {
                value = stringValue
            } else if let intValue = try? container.decode(Int.self) {
                value = intValue
            } else if let boolValue = try? container.decode(Bool.self) {
                value = boolValue
            // Array (중요: 내부 요소도 Json으로 재귀 디코딩)
            } else if let arrayValue = try? container.decode([Json].self) {
                value = arrayValue.map { $0.value }
            } else {
                throw DecodingError.dataCorruptedError
            }
        } else {
            throw DecodingError.dataCorruptedError
        }
    }
}

let json = """
{
    "pageTitle": "Pets",
    "rating": 4,
    "isHidden": true,
    "components": [
        {
            "type": "featuredImage",
            "data": {
                "imageUrl": "https://images.unsplash.com/photo-1517331156700-3c241d2b4d83"
            }
        }
    ]
}
"""

func test() {
    let decoded = try? JSONDecoder().decode(Json.self, from: json.data(using: .utf8)!).value
    print("decoded: \(decoded as! [String: Any])")
}
