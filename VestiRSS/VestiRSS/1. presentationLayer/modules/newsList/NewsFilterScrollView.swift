//
//  newsFilterScrollView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 16.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsFilterScrollView: UIScrollView {
    
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
        for i in 0..<20 {
            let filterButton = UIButton.init(frame: CGRect.zero)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            
            filterButton.backgroundColor = UIColor.blue
            addSubview(filterButton)
            
            setupLayout(for: filterButton, title: i)
        }
        trailingButtonContraint.isActive = true 
        
    }
    
    private func setupLayout(for button: UIButton, title: Int) {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingContraint, constant: 5),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.widthAnchor.constraint(equalToConstant: 75)
        ])
        
        leadingContraint = button.trailingAnchor
        trailingButtonContraint = button.trailingAnchor.constraint(equalTo: trailingAnchor)
        button.setTitle("Button \(title)", for: .normal)
        button.addTarget(self, action: #selector(scrollViewButtonAction), for: .touchUpInside)
    }
    
    @objc private func scrollViewButtonAction(_ sender: Any?){
        if let t_sender = sender as? UIButton {
        }
    }
}

