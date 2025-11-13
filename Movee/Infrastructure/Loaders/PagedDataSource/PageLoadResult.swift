//
//  PageLoadResult.swift
//  Movee
//
//  Created by user on 11/11/25.
//

struct PageLoadResult<Item> {
    let items: [Item]
    let hasMore: Bool
    let isFirstPage: Bool
}
