//
//  NewsListParser.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

final class NewsListParser: NSObject, XMLParserDelegate {
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
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
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
    
    //MARK: XML Parser Delegate
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
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
        if currentElement == "item" {
//            currentImageURL = ""
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "pubDate":
            currentPubDate += string
        case "yandex:full-text":
            currentDescription += string
        case "category":
            currentCategory += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSNewsItem(imageURL: currentImageURL,
                                      title: currentTitle,
                                      pubDate: currentPubDate,
                                      description: currentDescription,
                                      category: currentCategory)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
