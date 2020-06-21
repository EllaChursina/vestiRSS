//
//  PresentationAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

protocol PresentationAssembly {
    
    func newsListViewController() -> NewsListViewController
    func newsViewController(with rssItem: NewsItem) -> NewsViewController
}

final class PresentationAssemblyImpl: PresentationAssembly {
    
    private let serviceAssembly: ServiceAssembly
    
    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func newsListViewController() -> NewsListViewController {
        let vc = NewsListViewController(
            presentationAssembly: self,
            networkManager: serviceAssembly.networkManager,
            newsListViewControllerDataProvider: serviceAssembly.newsListViewControllerDataProvider
        )
        return vc
    }
    
    func newsViewController(with rssItem: NewsItem) -> NewsViewController {
        let vc = NewsViewController(networkManager: serviceAssembly.networkManager, rssItem: rssItem)
        
        return vc
    }
}

