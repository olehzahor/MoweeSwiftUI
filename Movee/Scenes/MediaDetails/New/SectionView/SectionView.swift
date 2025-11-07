//
//  SectionView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI

struct SectionView<Content: View>: View {
    @Environment(\.isLoading) private var isLoading: Bool
    @Environment(\.errorConfig) private var errorConfig: ErrorConfiguration?

    let header: SectionHeaderData
    @ViewBuilder let content: () -> Content
    
    private var minimalHeader: SectionHeaderData {
        SectionHeaderData(title: header.title)
    }
    
    private var activeHeader: SectionHeaderData {
        if errorConfig?.error != nil {
            minimalHeader
        } else {
            isLoading ? minimalHeader : header
        }
    }
        
    @ViewBuilder
    func sectionContainer(header: SectionHeaderData, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(data: activeHeader)
            content()
        }
    }

    var body: some View {
        sectionContainer(header: header, content: content)
    }
}
