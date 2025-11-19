//
//  Route.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    @ViewBuilder var view: Destination { get }
}
