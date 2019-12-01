//
//  APIClient.swift
//  SwiftSample
//
//  Created by Mutsumi Kakuta on 2019/12/01.
//  Copyright © 2019 Mutsumi Kakuta. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestError: Error {
    case invalidRequest
}

struct APIRequest {
    var method: HTTPMethod
    var path: String
    var parameters: [String: Any]
}

final class APIClient {
    let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()
    private let baseURL = URL(string: "https://XXXX.com")!
        
    func buildMultipartFormURLRequest(from request: APIRequest) throws -> URLRequest {
        guard case .post = request.method else { throw RequestError.invalidRequest }
        let uniqueId = UUID().uuidString
        let boundary = "---------------------------\(uniqueId)"
        let url = baseURL.appendingPathComponent(request.path)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.url = url
        urlRequest.httpBody = try multiData(withJSONObject: request.parameters, boundary: boundary, uniqueId: uniqueId)
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
        
    private func multiData(withJSONObject objects: [String: Any], boundary: String, uniqueId: String) throws -> Data {
        let boundaryText = "--\(boundary)\r\n"
        var data = Data()

        for (key, value) in objects {
            switch value {
            case let image as UIImage:
                guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    throw RequestError.invalidRequest
                }
                data.append(boundaryText.data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(uniqueId).jpg\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/jpeg\r\n".data(using: .utf8)!)
                data.append("\r\n".data(using: .utf8)!)
                data.append(imageData)
                data.append("\r\n".data(using: .utf8)!)
            case let string as String:
                data.append(boundaryText.data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
                data.append("\r\n".data(using: .utf8)!)
                data.append(string.data(using: .utf8)!)
                data.append("\r\n".data(using: .utf8)!)
            case let int as Int:
                data.append(boundaryText.data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n".data(using: .utf8)!)
                data.append("\r\n".data(using: .utf8)!)
                data.append(String(int).data(using: .utf8)!)
                data.append("\r\n".data(using: .utf8)!)
            default:
                throw RequestError.invalidRequest
            }
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return data
    }
}

// APIClientの使用例

class SampleAPICall {
    
    func sendMultipartFormRequest() {
        guard let image = UIImage(named: "image") else {
            fatalError("Invalid imageName")
        }
        
        let apiClient = APIClient()
        let request = APIRequest(
            method: .post,
            path: "/files",
            parameters: [
                "file": image,
                "id": 1234,
        ])
        
        do {
            let urlRequest = try apiClient.buildMultipartFormURLRequest(from: request)
            let task = apiClient.session.dataTask(with: urlRequest) { data, response, error in
                //成功した時の処理
            }
            task.resume()
        } catch {
            //エラーハンドリング
        }
    }
}
