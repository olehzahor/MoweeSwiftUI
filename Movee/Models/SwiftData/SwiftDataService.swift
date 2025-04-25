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
    // MARK: - Create
    func create(_ model: ModelType) throws {
        modelContext.insert(model)
        try modelContext.save()
    }

    // MARK: - Read
    func fetch(predicate: Predicate<ModelType>? = nil, sort: [SortDescriptor<ModelType>] = [], limit: Int? = nil) throws -> [ModelType] {
        var fetchDescriptor = FetchDescriptor<ModelType>(predicate: predicate, sortBy: sort)
        if let limit {
            fetchDescriptor.fetchLimit = limit
        }
        return try modelContext.fetch(fetchDescriptor)
    }

    // MARK: - Update
    func update(_ model: ModelType) throws {
        // Directly save as the model is guaranteed to exist in context
        try modelContext.save()
    }

    // MARK: - Delete
    func delete(_ model: ModelType) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func reset() throws {
        try modelContext.delete(model: ModelType.self)
    }
}
