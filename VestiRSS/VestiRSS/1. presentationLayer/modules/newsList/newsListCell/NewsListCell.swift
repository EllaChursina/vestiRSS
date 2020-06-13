//
//  NewsListCell.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

final class NewsListCell: UITableViewCell, CongigurableView {
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "newsTitleLabel"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(publicationTimeLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            newsTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
        
        publicationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationTimeLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 4),
            publicationTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            publicationTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            publicationTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with model: NewsCell) {
        newsTitleLabel.text = model.title
        publicationTimeLabel.text = model.publicationTime
    }

}
