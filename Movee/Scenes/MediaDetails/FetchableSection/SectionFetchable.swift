//
//  SectionFetchable.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

/// Protocol for ViewModels that support fetchable sections with loading states
protocol SectionFetchable: AnyObject {
    associatedtype SectionType: Hashable
    @MainActor var sectionsContext: AsyncLoadingContext<SectionType> { get set }
    @MainActor var fetchConfigs: [SectionType: AnyFetchConfig] { get }
}
