//
//  HorizontalCollectionViewCell.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 27.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    let collectionVIew: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .purple
        collectionView.isPagingEnabled = true
        
        return collectionView
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
        addSubview(collectionVIew)
        
        [collectionVIew.topAnchor.constraint(equalTo: self.topAnchor),
         collectionVIew.trailingAnchor.constraint(equalTo: self.trailingAnchor),
         collectionVIew.leadingAnchor.constraint(equalTo: self.leadingAnchor),
         collectionVIew.bottomAnchor.constraint(equalTo: self.bottomAnchor)].forEach { $0.isActive = true }
        
        collectionVIew.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionVIew.dataSource = self
        collectionVIew.delegate = self
    }
    
    let colors: [UIColor] = [.red, .yellow, .green]
}

extension HorizontalCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
}

extension HorizontalCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


