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
}

final class ServiceAssemblyImpl: ServiceAssembly {
    
    private let coreAssembly: CoreAssembly
    
    init(coreAssembly: CoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var networkManager = NetworkManager(newsListParser: coreAssembly.newsListParser, newsCategoryParser: coreAssembly.newsCategoryParser)
}
