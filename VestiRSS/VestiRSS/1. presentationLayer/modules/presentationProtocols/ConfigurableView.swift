//
//  ConfigurableView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol CongigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
