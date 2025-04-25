//
//  MediaPersonDetailsView.swift
//  Movee
//
//  Created by user on 4/15/25.
//

import SwiftUI

struct MediaPersonsListView: View {
    @StateObject var viewModel: MediaPersonsListViewModel
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 3
    )
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.departments, id: \.self) { department in
                VStack(alignment: .leading, spacing: 8) {
                    Text(department)
                        .textStyle(.sectionTitle)
                        .padding(.horizontal)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.getPersons(forDepartment: department), id: \.creditID) { person in
                            NavigationLink {
                                PersonDetailsView(person: person)
                            } label: {
                                PersonMediumView(person: person)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            }
        }.navigationTitle(viewModel.navigationTitle)
    }
    
    init(persons: [MediaPerson]) {
        _viewModel = StateObject(wrappedValue: MediaPersonsListViewModel(persons: persons))
    }
}

struct MediaPersonsListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPersonsListView(persons: [
            MediaPerson(
                id: 1,
                type: .cast,
                name: "John Doe",
                profilePath: "/sampleProfile1.jpg",
                role: "Director",
                creditID: "credit123",
                gender: 2,
                castID: nil,
                order: nil
            ),
            MediaPerson(
                id: 2,
                type: .cast,
                name: "Jane Smith",
                profilePath: "/sampleProfile2.jpg",
                role: "Actress",
                creditID: "credit456",
                gender: 1,
                castID: 10,
                order: 1
            ),
            MediaPerson(
                id: 3,
                type: .crew,
                name: "Sam Johnson",
                profilePath: nil,
                role: nil,
                department: "Directing",
                creditID: "credit789",
                gender: 2,
                castID: 12,
                order: 2
            )
        ])
    }
}
