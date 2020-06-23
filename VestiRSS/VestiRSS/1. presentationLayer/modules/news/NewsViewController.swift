//
//  NewsViewController.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
    
    // MARK: DI
    
    private let imageNetworkService: ImageNetworkService
    
    // MARK: Data
    
    private let rssItem: NewsItem
    
    // MARK: UI
    
    private let contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView()
        contentScrollView.accessibilityIdentifier = "contentScrollView"
        contentScrollView.backgroundColor = .white
        contentScrollView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        return contentScrollView
    }()
    
    private let newsView: NewsView = {
        let newsView = NewsView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        newsView.accessibilityIdentifier = "newsView"
        
        return newsView
    }()
    
    // MARK: Initialization
    
    init(imageNetworkService: ImageNetworkService, rssItem: NewsItem) {
        self.imageNetworkService = imageNetworkService
        self.rssItem = rssItem
        
        super.init(nibName: nil, bundle: nil)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        contentScrollView.addSubview(newsView)
        view.addSubview(contentScrollView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
        newsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            newsView.leftAnchor.constraint(equalTo: contentScrollView.leftAnchor),
            newsView.rightAnchor.constraint(equalTo: contentScrollView.rightAnchor),
            newsView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            newsView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        configureNewsView(with: rssItem)
    }
    
    private func fetchImage() {
        imageNetworkService.downloadImage(with: rssItem.imageURL) { [weak self] (image) in
            DispatchQueue.global().async {
                self?.newsView.configureImage(with: image)
            }
        }
    }
    
    func configureNewsView(with rssItem: NewsItem) {
        
        let model = NewsViewModel(title: rssItem.title, publicationTime: rssItem.pubDate, description: rssItem.description)
        newsView.configureData(with: model)
        
        fetchImage()
    }
}
