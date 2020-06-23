//
//  newsFilterScrollView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 16.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

protocol NewsFilterScrollViewDelegate: AnyObject {
    func fitlerButtonTapped(with text: String)
}

final class NewsFilterScrollView: UIScrollView {
    
    weak var filterDelegate: NewsFilterScrollViewDelegate?
    
    // MARK: Data
    
    var categories = [String]() {
        didSet {
            self.setupView()
        }
    }
    
    private var currentButton: FilterButton?
    
    // MARK: Contsraints
    
    private var leadingContraint: NSLayoutXAxisAnchor!
    private var trailingButtonContraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton || view is UILabel {
            return true
        }
        
        return touchesShouldCancel(in: view)
    }
    
    private func setupView() {
        subviews.forEach { $0.removeFromSuperview() }
        currentButton = nil
        
        leadingContraint = self.leadingAnchor
        guard !categories.isEmpty else { return }
        
        for category in categories {
            let filterButton = FilterButton()
            
            if currentButton == nil {
                currentButton = filterButton
                currentButton?.isSelected = true
            }
            
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.sizeThatFits(CGSize.zero)
            
            addSubview(filterButton)
            setupLayout(for: filterButton, title: category)
        }
        
        trailingButtonContraint.isActive = true
    }
    
    private func setupLayout(for button: FilterButton, title: String) {
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingContraint, constant: 5),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        leadingContraint = button.trailingAnchor
        trailingButtonContraint = button.trailingAnchor.constraint(equalTo: trailingAnchor)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(scrollViewButtonAction), for: .touchUpInside)
    }
    
    @objc private func scrollViewButtonAction(_ sender: Any?) {
        guard let senderButton = sender as? FilterButton, let currentButton = currentButton else {
            return
        }
        
        currentButton.isSelected = false
        self.currentButton = senderButton
        self.currentButton?.isSelected = true
        
        if let buttonText = senderButton.titleLabel?.text {
            filterDelegate?.fitlerButtonTapped(with: buttonText)
        }
    }
}
