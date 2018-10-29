//
//  CollectionViewHeader.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class TabLayoutCollectionViewHeader: UICollectionReusableView {
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First Tab"
        label.textAlignment = .center

        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Second Tab"
        label.textAlignment = .center

        return label
    }()
    
    let thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Third Tab"
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel, thirdLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialzie()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialzie() {
        clipsToBounds = true
        addSubview(stackView)
        
        [stackView.topAnchor.constraint(equalTo: self.topAnchor),
         stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         stackView.heightAnchor.constraint(equalToConstant: 70)].forEach { $0.isActive = true }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
}
