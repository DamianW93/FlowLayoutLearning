//
//  StreatchyHeaderViewController.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class TabLayoutViewController: UICollectionViewController {
    
    var photos = Photo.allPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = UIView()
        
        let layout = TabsCustomFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
//        layout.headerReferenceSize = CGSize(width: self.collectionView.bounds.width, height: 200)

        initializeCollectionView()
    }
    
    private func initializeCollectionView() {
        self.collectionView.register(StreatchyHeaderView.self,
                                     forSupplementaryViewOfKind: ListElement.header.kind,
                                     withReuseIdentifier: ListElement.header.identifier)
        self.collectionView.register(TabLayoutCollectionViewHeader.self,
                                     forSupplementaryViewOfKind: ListElement.tabLayout.kind,
                                     withReuseIdentifier: ListElement.tabLayout.identifier)
        
        self.collectionView.register(HorizontalCollectionViewCell.self,
                                     forCellWithReuseIdentifier: ListElement.cell.identifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListElement.cell.identifier, for: indexPath) as? HorizontalCollectionViewCell {
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case ListElement.header.kind:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListElement.header.identifier, for: indexPath)
            if let sectionHeaderView = supplementaryView as? StreatchyHeaderView {
                sectionHeaderView.backgroundColor = .blue
            }
            return supplementaryView
        case ListElement.tabLayout.kind:
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ListElement.tabLayout.identifier, for: indexPath)
            if let tabLayout = supplementaryView as? TabLayoutCollectionViewHeader {
                tabLayout.backgroundColor = .red
            }
            return supplementaryView
        default: fatalError("Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HorizontalCollectionViewCell {
            cell.collectionVIew.reloadData()
        }
    }
}

extension TabLayoutViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 200)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 100)
//    }
}
