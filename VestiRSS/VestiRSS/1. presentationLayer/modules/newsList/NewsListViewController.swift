//
//  NewsListViewController.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsListViewController: UIViewController {

    // MARK: DI
    
    private let presentationAssembly: PresentationAssembly
    
    // MARK: Views
    
    private let newsListTableView = UITableView()
    
    private var rssItems: [RSSNewsItem]?
    
    init(presentationAssembly: PresentationAssembly) {
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        
        fetchData()
    }
    
    private func prepareTableView() {
        view.addSubview(newsListTableView)
        
        newsListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            newsListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            newsListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            newsListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        newsListTableView.dataSource = self
        newsListTableView.delegate = self
        
        newsListTableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.identifier)
    }
    
    private func fetchData(){
        let newsListParser = NewsListParser()
        newsListParser.parseFeed(url: "https://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            
            DispatchQueue.main.async {
                self.newsListTableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsListCell = tableView.dequeue(for: indexPath)
        var newsItem: NewsCell
        if let item = rssItems?[indexPath.item]{
            newsItem = NewsCell(title: item.title, publicationTime: item.pubDate)
            cell.configure(with: newsItem)
        }
        
        return cell
    }
}

extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = presentationAssembly.newsViewController()
        var newsItem: NewsViewModel
        if let item = rssItems?[indexPath.item]{
            newsItem = NewsViewModel(newsImageURL: item.imageURL, title: item.title, publicationTime: item.pubDate, description: item.description)
            vc.configure(with: newsItem)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
