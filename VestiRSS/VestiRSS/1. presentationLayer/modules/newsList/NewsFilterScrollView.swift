//
//  newsFilterScrollView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 16.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsFilterScrollView: UIScrollView {
    
    // MARK: Data
    
    var categories = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.setupView()
            }
        }
    }
    
    var currentButton: FilterButton!
    // MARK: Contsraints
    
    var leadingContraint: NSLayoutXAxisAnchor!
    var trailingButtonContraint: NSLayoutConstraint!
    
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
        
        leadingContraint = self.leadingAnchor
        guard !categories.isEmpty else { return }
        for category in categories {
            let filterButton = FilterButton.init(frame: CGRect.zero)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            filterButton.sizeThatFits(CGSize.zero)
            addSubview(filterButton)
            if category == "Главные" {
                currentButton = filterButton
            }
            setupLayout(for: filterButton, title: category)
        }
        trailingButtonContraint.isActive = true
        currentButton.isHighlighted = true
        
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
    
    @objc private func scrollViewButtonAction(_ sender: Any?){
        if let senderButton = sender as? FilterButton {
            currentButton.isHighlighted = false
            currentButton = senderButton
            currentButton.isHighlighted = true
        }
    }
    
    func configure(with data: [String]) {
        categories = data
    }
}
