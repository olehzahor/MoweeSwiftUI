//
//  MediaFormatterService.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

struct MediaFormatterService {
    static let shared = MediaFormatterService()
    
    enum DateStyle {
        case short, full, relative
    }
    
    private let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private let parseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let fullDisplayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    private let shortDisplayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    private let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
        
    func parse(dateString: String) -> Date? {
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        return parseDateFormatter.date(from: dateString)
    }
    
    func format(date: Date?, style: DateStyle = .short) -> String {
        guard let date else { return "" }
        return switch style {
        case .short:
            shortDisplayDateFormatter.string(from: date)
        case .full:
            fullDisplayDateFormatter.string(from: date)
        case .relative:
            relativeDateFormatter.localizedString(for: date, relativeTo: Date())
        }
    }
    
    func format(currency amount: Int?) -> String {
        guard let amount else { return "" }
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
    
    func format(rating: Double?) -> String {
        guard let rating else { return "" }
        return String(format: "%.1f", rating)
    }
    
    func format(duration minutes: Int?) -> String {
        guard let minutes else { return "" }
        let seconds = TimeInterval(minutes * 60)
        return durationFormatter.string(from: seconds) ?? "N/A"
    }
        
    private init() {}
}
