//
//  NewsListCell.swift
//  VestiRSS
//
//  Created by Элла Чурсина on 11.06.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import UIKit

// MARK: Metrics

private enum Metrics {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
    static let internalPadding: CGFloat = 4
}

final class NewsCell: UITableViewCell {
    
    // MARK: Date Formatters
    
    private static let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    // MARK: UI
   
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
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(publicationTimeLabel)
        
        setupLayout()
    }
    
    private func setupLayout() {
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.verticalPadding),
            newsTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Metrics.horizontalPadding),
            newsTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Metrics.horizontalPadding)
        ])
        
        publicationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            publicationTimeLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: Metrics.internalPadding),
            publicationTimeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Metrics.horizontalPadding),
            publicationTimeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Metrics.horizontalPadding),
            publicationTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.verticalPadding)
        ])
    }
    
    func configure(with viewModel: NewsCellViewModel) {
        newsTitleLabel.text = viewModel.title
        publicationTimeLabel.text = viewModel.publicationTime
    }

}
