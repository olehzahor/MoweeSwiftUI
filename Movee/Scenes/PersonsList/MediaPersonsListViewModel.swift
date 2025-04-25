//
//  MediaPersonsListViewModel.swift
//  Movee
//
//  Created by user on 4/17/25.
//


import SwiftUI

class MediaPersonsListViewModel: ObservableObject {
    private var persons: [MediaPerson]
    
    private(set) var groupedPersons: [String: [MediaPerson]] = [:]
    private(set) var departments: [String] = []
    
    private(set) var navigationTitle: String = "Cast and crew"
    
    func getPersons(forDepartment department: String) -> [MediaPerson] {
        groupedPersons[department] ?? []
    }

    init(persons: [MediaPerson]) {
        self.persons = persons
        self.groupedPersons = Dictionary(grouping: persons, by: { $0.departmentGrouping })
        
        var popularityByDepartment: [String: Double] = [:]
        for (department, persons) in groupedPersons {
            let totalPopularity = persons.reduce(0.0) { $0 + ($1.popularity ?? 0.0) }
            let avgPopularity = persons.isEmpty ? 0.0 : totalPopularity / Double(persons.count)
            popularityByDepartment[department] = avgPopularity
        }
        
        self.departments = groupedPersons.keys.sorted {
            (popularityByDepartment[$0] ?? 0.0) >= (popularityByDepartment[$1] ?? 0.0)
        }
        
        for (department, persons) in groupedPersons {
            groupedPersons[department] = persons.sorted { $0.sorting <= $1.sorting }
        }
    }
}
