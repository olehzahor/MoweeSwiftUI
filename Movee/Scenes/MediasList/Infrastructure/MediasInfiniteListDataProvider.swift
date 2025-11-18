//
//  MediasInfiniteListDataProvider.swift
//  Movee
//
//  Created by user on 11/18/25.
//

protocol MediasInfiniteListDataProvider: InfiniteListDataProvider where Item == Media { }

extension PagedDataSource<Media>: MediasInfiniteListDataProvider { }
extension StoredItemsListDataProvider<Media>: MediasInfiniteListDataProvider { }
