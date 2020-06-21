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
}

final class NewsListViewController: UIViewController {
    
    // MARK: DI
    
    private let presentationAssembly: PresentationAssembly
    private let networkManager: NetworkManager
    private let newsListViewControllerDataProvider: NewsListViewControllerDataProvider

    
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
    
    // MARK: Data
    
    private var rssItems = [NewsItem]()
    private var currentCategory = Constants.topNewsCategoryName
    
    // MARK: Initialization
    
    init(
        presentationAssembly: PresentationAssembly,
        networkManager: NetworkManager,
        newsListViewControllerDataProvider: NewsListViewControllerDataProvider
    ) {
        self.presentationAssembly = presentationAssembly
        self.networkManager = networkManager
        self.newsListViewControllerDataProvider = newsListViewControllerDataProvider
        
        super.init(nibName: nil, bundle: nil)
        fetchCategories()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        prepareTableView()
        
    }
    
    private func setupView() {
        view.addSubview(newsFilterScrollView)
        view.addSubview(newsListTableView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        newsFilterScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsFilterScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsFilterScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsFilterScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            newsFilterScrollView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        newsListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
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
        
        newsListTableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
    }
    
    private func fetchData() {
        networkManager.downloadData(by: currentCategory) { [weak self] rssItems in
            DispatchQueue.global().async {
                self?.rssItems = rssItems
                DispatchQueue.main.async {
                    self?.newsListTableView.reloadData()
                }
            }
        }
    }
    
    private func fetchCategories() {
        DispatchQueue.main.async {
            self.newsFilterScrollView.categories = self.newsListViewControllerDataProvider.getNewsCategoryList()
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
    
    func filterNews(by category: String) {
        currentCategory = category
        fetchData()
    }
}

