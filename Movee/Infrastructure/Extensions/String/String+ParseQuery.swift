//
//  String+ParseQuery.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

extension String {
    func parseQueryString() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        for component in self.split(separator: "&") {
            let parts = component.split(separator: "=", maxSplits: 1).map(String.init)
            if parts.count == 2 {
                let key = parts[0]
                let value = parts[1]
                queryItems.append(URLQueryItem(name: key, value: value))
            } else if parts.count == 1 {
                // Handle parameters without values
                queryItems.append(URLQueryItem(name: parts[0], value: nil))
            }
        }
        
        return queryItems
    }
}
