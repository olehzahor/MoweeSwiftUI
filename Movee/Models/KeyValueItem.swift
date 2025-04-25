//
//  KeyValueItem.swift
//  Movee
//
//  Created by user on 4/11/25.
//

struct KeyValueItem<T>: Identifiable {
    internal var id: String { key }
    
    let key: String
    let value: T
}
