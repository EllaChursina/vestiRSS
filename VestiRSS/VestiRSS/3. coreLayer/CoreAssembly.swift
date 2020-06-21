//
//  CoreAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol CoreAssembly {
    var newsListParser: NewsListParser { get }
    var rssNewsCategoryProvider: RSSNewsCategoryProvider { get }
}

final class CoreAssemblyImpl: CoreAssembly {
    lazy var newsListParser = NewsListParser()
    lazy var rssNewsCategoryProvider = RSSNewsCategoryProvider()
}


