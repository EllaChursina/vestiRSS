//
//  NewsListViewControllerDataProvider.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 20.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

final class NewsListViewControllerDataProvider {
    private var newsCategoryProvider: NewsCategoryProvider
//    private var newsItemProvider: NewsItemProvider
    
    init(
        newsCategoryProvider: NewsCategoryProvider
//        newsItemProvider: NewsItemProvider
    ) {
        self.newsCategoryProvider = newsCategoryProvider
    }
    
    func getNewsCategoryList() -> [String] {
        return self.newsCategoryProvider.getAll()
    }
    
//    func getNewsList() -> [NewsItem] {
//        return self.newsItemProvider.getAll()()
//    }
}
