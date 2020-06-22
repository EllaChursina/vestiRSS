//
//  FilterButton.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 17.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class FilterButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.black : UIColor.white
            titleLabel?.font = isSelected
                ? UIFont.systemFont(ofSize: 14, weight: .bold)
                : UIFont.systemFont(ofSize: 14, weight: .semibold)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 4, right: 8)

    }
}
