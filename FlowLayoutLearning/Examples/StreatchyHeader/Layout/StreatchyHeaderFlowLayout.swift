//
//  StreatchyHeaderFlowLayout.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class StreatchyHeaderFlowLayout: UICollectionViewFlowLayout {
    
//    private var cache = [String: [IndexPath: CustomLayoutAttributes]]()
    private var contentOffset: CGPoint {
        return collectionView!.contentOffset
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public class var layoutAttributesClass: AnyClass {
        return StreatchyHeaderAttributes.self
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
        let contentOffset = collectionView?.contentOffset ?? CGPoint(x: 0, y: 0)
        
        if contentOffset.y < 0 {

            let deltaY = abs(contentOffset.y)
            print("deltaY: \(deltaY)")

            for attribute in layoutAttributes {
                if let elementKind = attribute.representedElementKind, elementKind == UICollectionView.elementKindSectionHeader {
                    var frame = attribute.frame

                    frame.size.height = max(0, headerReferenceSize.height + deltaY)
                    frame.origin.y = frame.minY - deltaY
                    attribute.frame = frame
                }
//                else if let attributes = attribute as? TabLayoutCollectionViewHeader {
//                    attributes.transform = .identity
//                    attributes.transform = CGAffineTransform(
//                        translationX: 0,
//                        y: max(attributes.initialOrigin.y, contentOffset.y) - 200)
//                }
            }
        }
        
        if contentOffset.y > 0 {
            let deltaY = abs(contentOffset.y)
            
            for attribute in layoutAttributes {
                if let elementKind = attribute.representedElementKind, elementKind == UICollectionView.elementKindSectionHeader {
                    var frame = attribute.frame
                    
                    frame.origin.y = 0 + (deltaY > (headerReferenceSize.height - 100) ? (deltaY - headerReferenceSize.height + 100) : 0)
                    attribute.frame = frame
                }
            }
        }
        
        guard let collectionView = collectionView else {
            return nil
        }
        
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        // 1
        let halfHeight = collectionView.frame.height * 0.5
        let halfCellHeight = 100 * 0.5
        // 2
        for (type, elementInfos) in cache {
            for (indexPath, attributes) in elementInfos {
                // 3
                attributes.transform = .identity
                // 4
//                updateSupplementaryViews(
//                    type,
//                    attributes: attributes,
//                    collectionView: collectionView,
//                    indexPath: indexPath)
//                if attributes.frame.intersects(rect) {
//                    // 5
//                    if type == .cell,
//                        settings.isParallaxOnCellsEnabled {
//                        updateCells(attributes, halfHeight: halfHeight, halfCellHeight: halfCellHeight)
//                    }
                    visibleLayoutAttributes.append(attributes)
//                }
            }
        }
//        return visibleLayoutAttributes
        
        layoutAttributes.append(contentsOf: visibleLayoutAttributes)
        return layoutAttributes
    }
    
    private var visibleLayoutAttributes = [StreatchyHeaderAttributes]()

    
    private var cache = [String: [IndexPath: StreatchyHeaderAttributes]]()

    private var contentHeight: CGFloat = 0
    private var zIndex = 0
}

extension StreatchyHeaderFlowLayout {
    
    override func prepare() {
        guard let collectionView = collectionView, cache.isEmpty else {
            return
        }
        cache["TabLayout"] = [IndexPath: StreatchyHeaderAttributes]()
        contentHeight = 0
        zIndex = 0
//        oldBounds = collectionView.bounds
//        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let menuAttributes = StreatchyHeaderAttributes(
            forSupplementaryViewOfKind: "TabLayout",
            with: IndexPath(item: 0, section: 0))
        prepareAttributesForElement(kind: "TabLayout", attributes: menuAttributes)
        
        for section in 0 ..< collectionView.numberOfSections {
            
//            let sectionHeaderAttributes = CustomLayoutAttributes(
//                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
//                with: IndexPath(item: 0, section: section))
//            prepareElement(
//                size: sectionsHeaderSize,
//                type: .sectionHeader,
//                attributes: sectionHeaderAttributes)
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
//                let cellIndexPath = IndexPath(item: item, section: section)
//                let attributes = CustomLayoutAttributes(forCellWith: cellIndexPath)
//                let lineInterSpace = settings.minimumLineSpacing
//                attributes.frame = CGRect(
//                    x: 0 + settings.minimumInteritemSpacing,
//                    y: contentHeight + lineInterSpace,
//                    width: itemSize.width,
//                    height: itemSize.height
//                )
//                attributes.zIndex = zIndex
//                contentHeight = attributes.frame.maxY
//                cache[.cell]?[cellIndexPath] = attributes
                zIndex += 1
            }
            
//            let sectionFooterAttributes = CustomLayoutAttributes(
//                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
//                with: IndexPath(item: 1, section: section))
//            prepareElement(
//                size: sectionsFooterSize,
//                type: .sectionFooter,
//                attributes: sectionFooterAttributes)
        }
//        updateZIndexes()

    }

//    private func updateZIndexes(){
//        guard let sectionHeaders = cache[.sectionHeader] else {
//            return
//        }
//        var sectionHeadersZIndex = zIndex
//        for (_, attributes) in sectionHeaders {
//            attributes.zIndex = sectionHeadersZIndex
//            sectionHeadersZIndex += 1
//        }
//        cache[.menu]?.first?.value.zIndex = sectionHeadersZIndex
//    }
    
    private func prepareAttributesForElement(kind: String, attributes: StreatchyHeaderAttributes) {
        
        attributes.initialOrigin = CGPoint(x: 0, y: contentHeight)
        if kind == "TabLayout" {
            let tablayout = TabLayoutCollectionViewHeader()
            tablayout.layoutIfNeeded()
            let height = tablayout.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
            attributes.frame = CGRect(origin: attributes.initialOrigin, size: CGSize(width: collectionView!.frame.width, height: height))
        } else {
            
        }
//        attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)

        attributes.zIndex = zIndex
        zIndex += 1

        contentHeight = attributes.frame.maxY
        
        cache[kind]?[attributes.indexPath] = attributes
    }
    
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == "TabLayout" {
            return cache["Tablayout"]?[indexPath]
        } else {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }
}
