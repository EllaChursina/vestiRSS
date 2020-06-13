//
//  NewsView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsView: UIView, CongigurableView {
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "newsImageView"
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "newsTitleLabel"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private let publicationTimeLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "publicationTimeLabel"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "newsContentLabel"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(publicationTimeLabel)
        addSubview(descriptionLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            newsImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            newsImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            newsImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            newsTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            newsTitleLabel.rightAnchor.constraint(equalTo: leftAnchor, constant: -16)
        ])
        
        publicationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationTimeLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 8),
            publicationTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            publicationTimeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: publicationTimeLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func fetchImage(with urlString: String){
        DispatchQueue.global().async {
            
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.newsImageView.image = image
                    }
                }
            }
        }
    }
    
    func configure(with model: NewsViewModel){
        fetchImage(with: model.newsImageURL)
        newsTitleLabel.text = model.title
        publicationTimeLabel.text = model.publicationTime
        descriptionLabel.text = model.description
    }
}
