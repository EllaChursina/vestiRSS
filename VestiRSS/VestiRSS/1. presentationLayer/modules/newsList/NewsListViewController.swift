//
//  NewsListViewController.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

private enum Metrics {
    static let estimateHeight: CGFloat = 46
    static let filterScrollViewHeight: CGFloat = 103
}

final class NewsListViewController: UIViewController {
    
    // MARK: DI
    
    private let presentationAssembly: PresentationAssembly
    private var newsFeedNetworkService: NewsFeedNetworkService
    private var newsCategoriesNetworkService: NewsCategoriesNetworkService

    
    // MARK: UI
    
    private lazy var newsFilterScrollView : NewsFilterScrollView = {
        let newsFilterScrollView = NewsFilterScrollView(frame: CGRect.zero)
        newsFilterScrollView.accessibilityIdentifier = "newsFilterScrollView"
        newsFilterScrollView.backgroundColor = .white
        newsFilterScrollView.filterDelegate = self
        
        return newsFilterScrollView
    }()
    
    private let newsListTableView = UITableView()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: multithreading
    
    private let newsDataQueue = DispatchQueue(label: "ellachursina.VestiRSS.newsDataQueue", qos: .userInitiated)
    
    // MARK: Data
    
    private var rssItems = [NewsItem]()
    private var currentCategory = Constants.topNewsCategoryName
    
    // MARK: Initialization
    
    init(
        presentationAssembly: PresentationAssembly,
        newsFeedNetworkService: NewsFeedNetworkService,
        newsCategoriesNetworkService: NewsCategoriesNetworkService) {
        self.presentationAssembly = presentationAssembly
        self.newsFeedNetworkService = newsFeedNetworkService
        self.newsCategoriesNetworkService = newsCategoriesNetworkService
        
        super.init(nibName: nil, bundle: nil)
        
        self.newsFeedNetworkService.delegate = self
        self.newsCategoriesNetworkService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        fetchCategories()
        fetchData()
    }
        
    private func setupView() {
        view.addSubview(newsFilterScrollView)
        view.addSubview(newsListTableView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        newsFilterScrollView.translatesAutoresizingMaskIntoConstraints = false
        newsListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsFilterScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsFilterScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsFilterScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            newsFilterScrollView.heightAnchor.constraint(equalToConstant: Metrics.filterScrollViewHeight),
            
            newsListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsListTableView.topAnchor.constraint(equalTo: newsFilterScrollView.bottomAnchor),
            newsListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func prepareTableView() {
        view.addSubview(newsListTableView)
        
        newsListTableView.dataSource = self
        newsListTableView.delegate = self
        newsListTableView.refreshControl = refreshControl
        newsListTableView.estimatedRowHeight = Metrics.estimateHeight
        newsListTableView.backgroundColor = .white
        
        newsListTableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationBarTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: Constants.navigationBarBackButtonTitle, style: .plain, target: nil, action: nil)
    }
    
    private func fetchData() {
        newsDataQueue.async {
            self.newsFeedNetworkService.downloadData(by: self.currentCategory)
        }
    }
    
    private func fetchCategories() {
        newsDataQueue.async {
            self.newsCategoriesNetworkService.downloadCategories()
        }
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        fetchData()
        sender.endRefreshing()
    }
}


// MARK: UITableViewDataSource

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = tableView.dequeue(for: indexPath)
        
        let item = rssItems[indexPath.row]
        let newsItem = NewsCellViewModel(title: item.title, publicationTime: item.pubDate)
        cell.configure(with: newsItem)
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rssItem = rssItems[indexPath.row]
        let vc = presentationAssembly.newsViewController(with: rssItem)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: NewsFilterScrollViewDelegate

extension NewsListViewController: NewsFilterScrollViewDelegate {
    
    func fitlerButtonTapped(with text: String) {
        currentCategory = text
        fetchData()
    }
}

// MARK: NewsFeedNetworkServiceDelegate

extension NewsListViewController: NewsFeedNetworkServiceDelegate {
    
    func didFetchNews(news: [NewsItem]) {
        DispatchQueue.main.async {
            self.rssItems = news
            self.newsListTableView.reloadData()
        }
    }
}

// MARK: NewsCategoriesNetworkServiceDelegate

extension NewsListViewController: NewsCategoriesNetworkServiceDelegate {
    
    func didFetchCategories(categories: [String]) {
        DispatchQueue.main.async {
            self.newsFilterScrollView.categories = categories
        }
    }
}


