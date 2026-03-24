//
//  Constants.swift
//  Pets
//
//  Created by 김동현 on 3/24/26.
//

import Foundation

struct Constants {
    
    struct ScreenResources {
        // static let baseUrl = "localhost:3000"
        static let petListing = "pet-listing"
        
        // API endpoint 문자열을 받아서, 실제 요청에 사용할 URL 객체를 만들어주는 함수
        static func resource(for resourceName: String) -> URL? {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "localhost"
            components.port = 3000
            components.path = "/\(resourceName)"
            return components.url
        }
    }
    
    struct Urls {
        static let baseUrl = "http://localhost:3000"
        static let petListing = "\(baseUrl)/pet-listing"
    }
}
