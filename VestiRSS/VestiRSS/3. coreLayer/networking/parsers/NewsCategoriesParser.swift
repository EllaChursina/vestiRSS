//
//  NewsCategoryParser.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 22.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol NewsCategoriesParser {
    func parseData(url: String, completionHandler: (([String]) -> Void)?)
}

final class NewsCategoriesParserImpl: NSObject, NewsCategoriesParser {
    
    private var rssCategoryItems: [String] = [Constants.topNewsCategoryName]
    
    private var currentElement = ""
    
    private var currentCategory = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([String]) -> Void)?
    
    func parseData(url: String, completionHandler: (([String]) -> Void)?) {
        parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        
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
        }
        
        task.resume()
    }
}

// MARK: XML Parser Delegate
extension NewsCategoriesParserImpl: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssCategoryItems = [Constants.topNewsCategoryName]
    }
    
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssCategoryItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
