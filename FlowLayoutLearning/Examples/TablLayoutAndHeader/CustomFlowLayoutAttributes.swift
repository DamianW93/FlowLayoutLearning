//
//  CustomFlowLayoutAttributes.swift
//  FlowLayoutLearning
//
//  Created by Damian Włodarczyk on 27.10.2018.
//  Copyright © 2018 Damian Włodarczyk. All rights reserved.
//

import UIKit

class CustomFlowLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var initialOrigin: CGPoint = .zero
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? CustomFlowLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.initialOrigin = initialOrigin
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? CustomFlowLayoutAttributes else {
            return false
        }
        
        if otherAttributes.initialOrigin != initialOrigin { return false }
        return super.isEqual(object)
    }
}
