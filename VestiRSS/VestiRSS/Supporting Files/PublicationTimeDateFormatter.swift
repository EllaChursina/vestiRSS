//
//  PublicationTimeDateFormatters.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 22.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

final class PublicationTimeDateFormatter {
    
    // MARK: -Date Formatters
    
    private static let inputDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        
        return formatter
    }()
    
    private static let outputDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMMM HH:mm"
        return formatter
    }()
    
    static func convertDateFormat(for dateString: String) -> String? {
        guard let inputDate = PublicationTimeDateFormatter.inputDateFormatter.date(from: dateString) else {
            return nil
        }
        let outputDate = PublicationTimeDateFormatter.outputDateFormatter.string(from: inputDate)
        return outputDate
    }
}
