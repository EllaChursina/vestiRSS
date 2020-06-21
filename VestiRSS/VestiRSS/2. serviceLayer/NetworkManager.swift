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
    
    init(newsListParser: NewsListParser) {
        self.newsListParser = newsListParser
    }
    
    private let baseLink = Constants.baseLink 
    
    func downloadData(by category: String, completionHandler: @escaping ([NewsItem]) -> Void) {
        newsListParser.parseFeed(url: baseLink) { rssItems in
            var filteredCategory = [NewsItem]()
            if category == Constants.topNewsCategoryName {
                completionHandler(rssItems)
            } else {
                filteredCategory = rssItems.filter ({ return $0.category == category })
                completionHandler(filteredCategory)
            }
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
