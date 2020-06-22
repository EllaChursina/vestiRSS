//
//  ServiceAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 15.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol ServiceAssembly {
    var newsFeedNetworkService: NewsFeedNetworkService { get }
    var newsCategoriesNetworkService: NewsCategoriesNetworkService { get }
    var imageNetworkService: ImageNetworkService { get }
}

final class ServiceAssemblyImpl: ServiceAssembly {
    
    private let coreAssembly: CoreAssembly
    
    var newsFeedNetworkService: NewsFeedNetworkService
    
    var newsCategoriesNetworkService: NewsCategoriesNetworkService
    
    lazy var imageNetworkService: ImageNetworkService = ImageNetworkServiceImpl()
    
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
        self.newsFeedNetworkService = NewsFeedNetworkServiceImpl(newsListParser: coreAssembly.newsListParser)
        self.newsCategoriesNetworkService = NewsCategoriesNetworkServiceImpl(newsCategoriesParser: coreAssembly.newsCategoriesParser)
    }
}
