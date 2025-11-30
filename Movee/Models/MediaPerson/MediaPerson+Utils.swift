//
//  MediaPerson+Utils.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation
import UIKit

extension MediaPerson {
    var profilePictureURL: URL? {
        guard let profilePath else { return nil }
        return TMDBImageURLProvider.shared.url(path: profilePath, size: .w154)
    }

    var largeProfilePictureURL: URL? {
        guard let profilePath else { return nil }
        return TMDBImageURLProvider.shared.url(path: profilePath, size: .w780)
    }

    var placeholderImage: UIImage? {
        switch gender {
        case 1:
            UIImage(resource: .imageFemalePersonPlaceholder)
        default:
            UIImage(resource: .imageMalePersonPlaceholder)
        }
    }

    var departmentGrouping: String {
        if let department {
            switch type {
            case .cast:
                return "Acting"
            default:
                return department
            }
        } else {
            return type.title
        }
    }

    var sorting: Double {
        if let order { return Double (order) }
        else { return 1 / (popularity ?? 1.0) }
    }
}
