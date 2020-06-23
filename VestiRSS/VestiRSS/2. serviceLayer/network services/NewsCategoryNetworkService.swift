//
//  NewsCategoryNetworkService.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 22.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol NewsCategoriesNetworkServiceDelegate: AnyObject {
    func didFetchCategories(categories: [String])
}

protocol NewsCategoriesNetworkService {
    var delegate: NewsCategoriesNetworkServiceDelegate? { get set }
    func downloadCategories()
}

final class NewsCategoriesNetworkServiceImpl: NewsCategoriesNetworkService{
    
    weak var delegate: NewsCategoriesNetworkServiceDelegate?
    
    private let newsCategoriesParser: NewsCategoriesParser
    
    init(newsCategoriesParser: NewsCategoriesParser) {
        self.newsCategoriesParser = newsCategoriesParser
    }
    
    private let baseLink = Constants.baseLink
    
    func downloadCategories() {
        newsCategoriesParser.parseData(url: baseLink) { rssItems in
            self.delegate?.didFetchCategories(categories: rssItems)
        }
    }
    
}
