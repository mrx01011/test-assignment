//
//  Untitled.swift
//  test-assignment
//
//  Created by Vlad on 11.06.2025.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension Endpoint {
    var baseURL: URL {
        return URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1")!
    }
    var method: HTTPMethod { return .get }
    var parameters: [String: Any]? { return nil }
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if let parameters = parameters {
            if method == .get {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = components?.url
            } else {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }
        }
        
        return request
    }
}
