//
//  StreatchyHeaderViewController.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class StreatchyHeaderViewController: UICollectionViewController {
    
    var photos = Photo.allPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = UIView()
        
        let layout = StreatchyHeaderFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width, height: 200)

        initializeCollectionView()
    }
    
    private func initializeCollectionView() {
        self.collectionView.register(StreatchyCollectionViewHeader.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
        self.collectionView.register(TabLayoutCollectionViewHeader.self, forSupplementaryViewOfKind: "TabLayout", withReuseIdentifier: "tablayoutHeader")
        
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell {
            cell.imageView.image = photos[indexPath.item].image
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            if let sectionHeaderView = supplementaryView as? StreatchyCollectionViewHeader {
                sectionHeaderView.backgroundColor = .blue
            }
            return supplementaryView
        case "TabLayout":
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tablayoutHeader", for: indexPath)
            if let tabLayout = supplementaryView as? TabLayoutCollectionViewHeader {
                tabLayout.backgroundColor = .red
            }
            return supplementaryView
        default: fatalError("Unexpected element kind")
        }
    }
}

extension StreatchyHeaderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
