//
//  FailedSectionsReloadable.swift
//  Movee
//
//  Created on 24.10.2025.
//

import Foundation

/// Protocol for ViewModels that can reload all failed sections at once
protocol FailedSectionsReloadable: SectionFetchable where SectionType: CaseIterable {
    func reloadFailedSections()
}

extension FailedSectionsReloadable {
    /// Default implementation that retries all sections that are in error state
    @MainActor
    func reloadFailedSections() {
        for section in SectionType.allCases {
            if sectionsContext[section].error != nil {
                fetch(section)
            }
        }
    }
}
