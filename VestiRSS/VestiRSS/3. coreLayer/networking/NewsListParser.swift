//
//  NewsListParser.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

private enum XMLElement: String {
    case title
    case pubDate
    case fullText = "yandex:full-text"
    case category
}

final class NewsListParser: NSObject {
    
    private var rssItems: [RSSNewsItem] = []
    
    private var currentElement = ""
    
    private var currentImageURL = "" {
        didSet {
            currentImageURL = currentImageURL.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentCategory = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSNewsItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSNewsItem]) -> Void)?) {
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

extension NewsListParser: XMLParserDelegate {
        
        func parser(_ parser: XMLParser,
                    didStartElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?,
                    attributes attributeDict: [String: String] = [:]) {
            switch elementName {
            case "item":
                currentTitle = ""
                currentDescription = ""
                currentPubDate = ""
                currentImageURL = ""
            case "enclosure":
                if let urlString = attributeDict["url"] {
                    currentImageURL += urlString
                }
            default:
                break
            }
            
            currentElement = elementName
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            guard let element = XMLElement(rawValue: currentElement) else {
                return
            }
            
            switch element {
            case .title:
                currentTitle += string
            case .pubDate:
                currentPubDate += string
            case .fullText:
                currentDescription += string
            case .category:
                currentCategory += string
            }
        }
        
        func parser(_ parser: XMLParser,
                    didEndElement elementName: String,
                    namespaceURI: String?,
                    qualifiedName qName: String?) {
            guard elementName == "item" else {
                return
            }
            
            let rssItem = RSSNewsItem(imageURL: currentImageURL,
                                      title: currentTitle,
                                      pubDate: currentPubDate,
                                      description: currentDescription,
                                      category: currentCategory)
             rssItems.append(rssItem)
        }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            parserCompletionHandler?(rssItems)
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            print(parseError.localizedDescription)
        }
}
