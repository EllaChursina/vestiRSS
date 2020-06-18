//
//  NewsView.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 13.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

// MARK: Metrics

private enum Metrics {
    static let padding: CGFloat = 16
    static let bottomPadding: CGFloat = 8
}

final class NewsView: UIView {
    
    // MARK: UI
    
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
    
    // MARK: Constraints
    
    private var aspectRatioConstraint: NSLayoutConstraint!
    private var topNewsImageConstraint: NSLayoutConstraint!
    private var leftNewsImageConstraint: NSLayoutConstraint!
    private var rightNewsImageConstraint: NSLayoutConstraint!
    
    private var topTitleLabelConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
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
        
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: Metrics.bottomPadding),
            newsTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.padding),
            newsTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.padding)
        ])
        
        publicationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationTimeLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: Metrics.bottomPadding),
            publicationTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.padding),
            publicationTimeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.padding)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: publicationTimeLabel.bottomAnchor, constant: Metrics.padding),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.padding),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.padding),
            
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Metrics.padding)
        ])
    }
    
    func configure(with model: NewsViewModel) {
        if let image = model.image {
            newsImageView.image = model.image
            DispatchQueue.main.async {
                self.updateConstraints(for: image)
            }
        }
        newsTitleLabel.text = model.title
        publicationTimeLabel.text = model.publicationTime
        descriptionLabel.text = model.description
    }
    
    private func updateConstraints(for image: UIImage) {
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false

        let aspectRatio = image.size.width / image.size.height
        
        aspectRatioConstraint = newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor,
                                                                     multiplier: aspectRatio)

        topNewsImageConstraint = newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.padding)
        leftNewsImageConstraint = newsImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.padding)
        rightNewsImageConstraint = newsImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.padding)
        
        topTitleLabelConstraint = newsTitleLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor,
        constant: Metrics.bottomPadding)

        NSLayoutConstraint.activate([
            topNewsImageConstraint,
            leftNewsImageConstraint,
            rightNewsImageConstraint,
            topTitleLabelConstraint,
            aspectRatioConstraint
        ])
    }
}
