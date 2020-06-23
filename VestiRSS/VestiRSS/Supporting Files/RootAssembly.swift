//
//  RootAssembly.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

class RootAssembly {
    private lazy var coreAssembly: CoreAssembly = CoreAssemblyImpl() 
    
    private lazy var serviceAssembly: ServiceAssembly = ServiceAssemblyImpl(coreAssembly: self.coreAssembly)
    
    lazy var presentationAssembly: PresentationAssembly = PresentationAssemblyImpl(serviceAssembly: self.serviceAssembly)
}
