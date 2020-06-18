//
//  ImageManager.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 15.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NetworkManager {
    
    private let newsListParser : NewsListParser
    private let newsCategoryParser: NewsCategoryParser
    
    init(newsListParser: NewsListParser, newsCategoryParser: NewsCategoryParser) {
        self.newsListParser = newsListParser
        self.newsCategoryParser = newsCategoryParser
    }
    
    private let baseLink = "https://www.vesti.ru/vesti.rss"
    
    func downloadData(completionHandler: @escaping ([RSSNewsItem]) -> Void) {
        newsListParser.parseFeed(url: baseLink) { rssItems in
            completionHandler(rssItems)
        }
    }
    
    func downloadCategories(completionHandler: @escaping ([String]) -> Void) {
        newsCategoryParser.parseCategories(url: baseLink) { categories in
            completionHandler(categories)
        }
    }
    
    func downloadImage(with urlString: String, completionHandler: @escaping (UIImage?) -> Void) {
            guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                    return completionHandler(nil)
            }
        completionHandler(image)
    }
    
}
