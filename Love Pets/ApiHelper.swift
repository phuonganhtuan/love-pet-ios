//
//  ApiHelper.swift
//  Love Pets
//
//  Created by Phương Anh Tuấn on 30/03/2021.
//

import Foundation

class ApiHelper {
    
    func sendRequest(_ url: String, parameters: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, error)
                    return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
