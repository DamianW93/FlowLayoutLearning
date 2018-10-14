//
//  CollectionViewHeader.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "01")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
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
        addSubview(imageView)
        
        [imageView.topAnchor.constraint(equalTo: self.topAnchor),
         imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         imageView.heightAnchor.constraint(equalToConstant: 200)].forEach { $0.isActive = true }
    }
}
