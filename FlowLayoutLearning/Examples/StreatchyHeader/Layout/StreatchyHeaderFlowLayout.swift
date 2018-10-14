//
//  StreatchyHeaderFlowLayout.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 14.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class StreatchyHeaderFlowLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []
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
        
        
        return layoutAttributes
    }
}
