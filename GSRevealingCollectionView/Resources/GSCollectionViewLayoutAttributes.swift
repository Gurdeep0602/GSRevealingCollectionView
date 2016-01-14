//
//  GSCollectionViewLayoutAttributes.swift
//  CustomCollection
//
//  Created by Gurdeep Singh on 13/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class GSCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var maskingValue : CGFloat = 1.0
    var shouldRasterize : Bool = true
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let attributes : GSCollectionViewLayoutAttributes = super.copyWithZone(zone) as! GSCollectionViewLayoutAttributes
        attributes.shouldRasterize = self.shouldRasterize
        attributes.maskingValue = self.maskingValue
        
        return attributes
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        let other = object as! GSCollectionViewLayoutAttributes
        
        return super.isEqual(object) && (self.shouldRasterize == other.shouldRasterize && self.maskingValue == other.maskingValue)
    }
    
}
