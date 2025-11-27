//
//  VideoResponse.swift
//  Movee
//
//  Created by user on 5/4/25.
//

import Foundation

struct VideoResponse: Decodable {
    let id: Int
    let results: [Video]
}
