//
//  CollectionList+Section.swift
//  Movee
//
//  Created by user on 11/10/25.
//

extension CollectionList {
    var section: MediasSection? {
        guard let dataProvider: MediasListDataProvider? = switch mediaType {
        case .themedList:
            ThemedListDataProvider(path: path ?? "")
        default:
            TypedMediasListDataProvider.customList(self)
        }
        else { return nil }
        return .init(title: name, dataProvider: dataProvider)
    }
}

extension TypedMediasListDataProvider {
    static func customList(_ list: CollectionList) -> Self? {
        guard let type = MediaType(list.mediaType),
              let path = list.path
        else { return nil }
        return .customList(type, path: path, query: list.query)
    }
}

extension ThemedListDataProvider {
    init(path: String) {
        let components = path.components(separatedBy: "/")
        let listID = components.last.flatMap(Int.init) ?? 0
        self.init(listID: listID)
    }
}
