//
//  NewsCategoryItems.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 16.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

final class RSSNewsCategoryProvider: NSObject {
    
    private var rssCategoryItems: [String] = [Constants.topNewsCategoryName]
    
    private var currentElement = ""
    
    private var currentCategory = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
}

// MARK: XML Parser Delegate

extension RSSNewsCategoryProvider: XMLParserDelegate {
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        switch elementName {
        case "item":
            currentCategory = ""
            
        default:
            break
        }
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "category":
            currentCategory += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        guard elementName == "item" else {
            return
        }
        if !rssCategoryItems.contains(currentCategory) {
            rssCategoryItems.append(currentCategory)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {}
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}

extension RSSNewsCategoryProvider: NewsCategoryProvider {
    func getAll() -> [String] {
        let request = URLRequest(url: URL(string: Constants.baseLink)!)
        let urlSession = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                    
                return
            }
                
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            semaphore.signal()
        }.resume()

        _ = semaphore.wait(wallTimeout: .distantFuture)

        return rssCategoryItems
    }
}
