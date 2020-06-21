//
//  ServiceAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 15.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol ServiceAssembly {
    var networkManager: NetworkManager { get }
    var newsListViewControllerDataProvider: NewsListViewControllerDataProvider { get }
}

final class ServiceAssemblyImpl: ServiceAssembly {
    
    lazy var networkManager = NetworkManager(newsListParser: coreAssembly.newsListParser)
    var newsListViewControllerDataProvider: NewsListViewControllerDataProvider
    private let coreAssembly: CoreAssembly
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
        self.newsListViewControllerDataProvider = NewsListViewControllerDataProvider(newsCategoryProvider: coreAssembly.rssNewsCategoryProvider)
    }
}
