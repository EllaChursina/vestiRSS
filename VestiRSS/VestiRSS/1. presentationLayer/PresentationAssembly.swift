//
//  PresentationAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    
    func newsListViewController() -> NewsListViewController
    
    func newsViewController() -> NewsViewController
}

final class PresentationAssembly: IPresentationAssembly {
    func newsListViewController() -> NewsListViewController {
        let vc = NewsListViewController(presentationAssembly: self)
        return vc
    }
    
    func newsViewController() -> NewsViewController {
        let vc = NewsViewController()
        return vc
    }
    
    
}

