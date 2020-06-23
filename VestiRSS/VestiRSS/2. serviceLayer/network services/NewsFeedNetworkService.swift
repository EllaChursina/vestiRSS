//
//  NewsItemNetworkService.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 22.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol NewsFeedNetworkServiceDelegate: AnyObject {
    func didFetchNews(news: [NewsItem])
}

protocol NewsFeedNetworkService {
    var delegate: NewsFeedNetworkServiceDelegate? { get set }
    func downloadData(by category: String)
}

final class NewsFeedNetworkServiceImpl: NewsFeedNetworkService{
    
    weak var delegate: NewsFeedNetworkServiceDelegate?
    
    private let newsListParser: NewsListParser
    
    init(newsListParser: NewsListParser) {
        self.newsListParser = newsListParser
    }
    
    private let baseLink = Constants.baseLink
    
    func downloadData(by category: String) {
        newsListParser.parseData(url: baseLink) { rssItems in
            if category == Constants.topNewsCategoryName {
                self.delegate?.didFetchNews(news: rssItems)
            } else {
                let filteredCategory = rssItems.filter ({ return $0.category == category })
                self.delegate?.didFetchNews(news: filteredCategory)
            }
        }
    }
}
