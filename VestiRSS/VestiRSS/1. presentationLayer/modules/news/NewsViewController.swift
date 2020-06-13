//
//  NewsViewController.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
    
    private let newsView: NewsView = {
        let newsView = NewsView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        newsView.accessibilityIdentifier = "newsView"
        return newsView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(newsView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        newsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configure(with model: NewsViewModel) {
        newsView.configure(with: model)
    }
}
