//
//  SwiftDataService.swift
//  Movee
//
//  Created by user on 4/22/25.
//

import SwiftData
import Foundation
import Combine

@ModelActor actor SwiftDataService<ModelType: PersistentModel> {
    func create(_ model: ModelType) throws {
        modelContext.insert(model)
        try modelContext.save()
    }

    func fetch(predicate: Predicate<ModelType>? = nil, sort: [SortDescriptor<ModelType>] = [], limit: Int? = nil) throws -> [ModelType] {
        var fetchDescriptor = FetchDescriptor<ModelType>(predicate: predicate, sortBy: sort)
        if let limit {
            fetchDescriptor.fetchLimit = limit
        }
        return try modelContext.fetch(fetchDescriptor)
    }

    func update(_ model: ModelType) throws {
        try modelContext.save()
    }

    func delete(_ model: ModelType) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func reset() throws {
        try modelContext.delete(model: ModelType.self)
    }
}
