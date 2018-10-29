//
//  TabsCustomFlowLayout.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 27.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

enum ListElement: String {
    case header
    case tabLayout
    case cell
    
    var identifier: String { return rawValue }
    var kind: String { return "Kind\(rawValue.capitalized)" }
}

class TabsCustomFlowLayout: UICollectionViewFlowLayout {
    
    private var contentHeight = CGFloat()
    private var oldBounds = CGRect.zero
    private var cache = [ListElement: [IndexPath: CustomFlowLayoutAttributes]]()
    private var visibleLayoutAttributes = [CustomFlowLayoutAttributes]()
    private var zIndex = 0
    
    private var headerSize: CGSize = .zero
    private var tabLayoutSize: CGSize = .zero

    override public class var layoutAttributesClass: AnyClass { return CustomFlowLayoutAttributes.self }
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: contentHeight)
    }
    
    private var collectionViewHeight: CGFloat { return collectionView?.frame.height ?? 0 }
    private var collectionViewWidth: CGFloat { return collectionView?.frame.width ?? 0 }
    private var contentOffset: CGPoint { return collectionView?.contentOffset ?? .zero }
}

extension TabsCustomFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }
    
    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        prepareCache()
        contentHeight = 0
        zIndex = 0
        oldBounds = collectionView.bounds
        
        // Header attributes
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: ListElement.header.kind, withReuseIdentifier: ListElement.header.identifier, for: IndexPath(item: 0, section: 0))
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        let size = CGSize(width: collectionView.frame.width, height: height)
        self.headerSize = size
        
        let headerAttributes = CustomFlowLayoutAttributes(
            forSupplementaryViewOfKind: ListElement.header.kind,
            with: IndexPath(item: 0, section: 0))
        prepareElement(size: size, type: .header, attributes: headerAttributes)
        
        // Tab layout attributes
        let tabLayout = collectionView.dequeueReusableSupplementaryView(ofKind: ListElement.tabLayout.kind, withReuseIdentifier: ListElement.tabLayout.identifier, for: IndexPath(item: 0, section: 0))
        tabLayout.layoutIfNeeded()
        let tabLayoutHeight = tabLayout.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        let tabLayoutSize = CGSize(width: collectionView.frame.width, height: tabLayoutHeight)
        self.tabLayoutSize = tabLayoutSize
        
        let tabLayoutAttributes = CustomFlowLayoutAttributes(
            forSupplementaryViewOfKind: ListElement.tabLayout.kind,
            with: IndexPath(item: 0, section: 0))
        prepareElement(size: tabLayoutSize, type: .tabLayout, attributes: tabLayoutAttributes)
        
        // Cells
        for section in 0 ..< collectionView.numberOfSections {
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let cellHeight = collectionView.frame.height - tabLayoutSize.height
                let cellSize = CGSize(width: collectionView.frame.width, height: cellHeight)
                
                let attributes = CustomFlowLayoutAttributes(forCellWith: cellIndexPath)
                let lineInterSpace: CGFloat = 0
                let minimumInteritemSpacing: CGFloat = 0
                attributes.frame = CGRect(
                    x: 0 + minimumInteritemSpacing,
                    y: contentHeight + lineInterSpace,
                    width: cellSize.width,
                    height: cellSize.height
                )
                
                attributes.zIndex = zIndex
                contentHeight = attributes.frame.maxY
                cache[.cell]?[cellIndexPath] = attributes
                zIndex += 1
            }
        }
        
        updateZIndexes()
    }
    
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.header] = [IndexPath: CustomFlowLayoutAttributes]()
        cache[.tabLayout] = [IndexPath: CustomFlowLayoutAttributes]()
        cache[.cell] = [IndexPath: CustomFlowLayoutAttributes]()
    }
    
    private func prepareElement(size: CGSize, type: ListElement, attributes: CustomFlowLayoutAttributes) {
        attributes.initialOrigin = CGPoint(x:0, y: contentHeight)
        attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)
        
        attributes.zIndex = zIndex
        zIndex += 1
        contentHeight = attributes.frame.maxY
        cache[type]?[attributes.indexPath] = attributes
    }
    
    private func updateZIndexes(){
        guard let cells = cache[.cell] else { return }
        var topZIndex = zIndex
        for (_, attributes) in cells {
            attributes.zIndex = topZIndex
            topZIndex += 1
        }
        cache[.tabLayout]?.first?.value.zIndex = topZIndex
    }
}

extension TabsCustomFlowLayout {
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cell]?[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        switch elementKind {
        case ListElement.header.kind: return cache[.header]?[indexPath]
        case ListElement.tabLayout.kind: return cache[.tabLayout]?[indexPath]
        default: return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        for (type, elementInfo) in cache {
            for (indexPath, attributes) in elementInfo {
                
                attributes.transform = .identity
                
                updateSupplementaryViews(
                    type,
                    attributes: attributes,
                    collectionView: collectionView,
                    indexPath: indexPath)
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
    
    private func updateSupplementaryViews(_ type: ListElement,
                                          attributes: CustomFlowLayoutAttributes,
                                          collectionView: UICollectionView,
                                          indexPath: IndexPath) {
        if type == .header {
            let updatedHeight = min(
                collectionView.frame.height,
                max(headerSize.height, headerSize.height - contentOffset.y))
            let scaleFactor = updatedHeight / headerSize.height
            let delta = (updatedHeight - headerSize.height) / 2
            let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            let translation = CGAffineTransform(
                translationX: 0,
                y: min(contentOffset.y, headerSize.height) + delta)
            attributes.transform = scale.concatenating(translation)
        }

        else if type == .tabLayout {
            attributes.transform = CGAffineTransform(
                translationX: 0,
                y: max(attributes.initialOrigin.y, contentOffset.y) - headerSize.height)
        }
    }
}
