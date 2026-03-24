//
//  Dictionary+Extensions.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

extension Dictionary {
    
    /**
     Dictionary를 `Decodable` 모델로 변환합니다.
     내부적으로 다음 과정을 거칩니다:
     1. `JSONSerialization`을 통해 Dictionary를 JSON Data로 변환
     2. `JSONDecoder`를 통해 Data를 원하는 모델로 디코딩
     - Returns: 디코딩된 모델 객체. 실패 시 `nil` 반환
     
     ## 사용 예시
     ```swift
     struct User: Decodable {
         let name: String
         let age: Int
     }
     
     let dict: [String: Any] = [
         "name": "동현",
         "age": 20
     ]
     
     let user: User? = dict.decode()
     print(user?.name) // "동현"
     ```
     */
    func decode<T: Decodable>() -> T? {
        // dictionary -> json data
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        
        // json data -> decodable Model
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
