//
//  GSCustomFlowLayout.swift
//  CustomCollection
//
//  Created by Gurdeep Singh on 13/01/16.
//  Copyright © 2016 Gurdeep Singh. All rights reserved.
//

import UIKit

class GSCustomFlowLayout: UICollectionViewFlowLayout {

    private var itemWidth : CGFloat = 286.0
    
    override init() {
        
        super.init()
        
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.itemSize = CGSizeMake(itemWidth, 180)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 200
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func layoutAttributesClass() -> AnyClass {
        return GSCollectionViewLayoutAttributes.self
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let layoutCollectionView = self.collectionView else {
            return nil
        }

        guard let originalLayoutAttributesArray = super.layoutAttributesForElementsInRect(rect) else {
            return nil
        }
        
        let layoutAttributesArray = originalLayoutAttributesArray.map { (attribute :UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes in
            
            return (attribute.copy() as! GSCollectionViewLayoutAttributes)
        }
        
        let visibleRect = CGRectMake( layoutCollectionView.contentOffset.x,
            layoutCollectionView.contentOffset.y,
            layoutCollectionView.bounds.width,
            layoutCollectionView.bounds.height
        )
        
        for attributes in layoutAttributesArray {
        
            if (CGRectIntersectsRect(attributes.frame, rect)) {
                self.applyLayoutAttributes(attributes as! GSCollectionViewLayoutAttributes, forVisibleRect: visibleRect)
            }
        }
        
        return layoutAttributesArray
    }

    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        guard let layoutCollectionView = self.collectionView else {
            return nil
        }

        guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) else {
            return nil
        }
        
        let visibleRect = CGRectMake( layoutCollectionView.contentOffset.x,
            layoutCollectionView.contentOffset.y,
            layoutCollectionView.bounds.width,
            layoutCollectionView.bounds.height
        )
        
        self.applyLayoutAttributes(attributes as! GSCollectionViewLayoutAttributes, forVisibleRect: visibleRect)
    
        return attributes         
    }

    func applyLayoutAttributes(attributes : GSCollectionViewLayoutAttributes, forVisibleRect visibleRect : CGRect) {
    
        if visibleRect.origin.x > 0 {
        
            let currentItemIndex = Int(visibleRect.origin.x / self.itemSize.width)
            
            if attributes.indexPath.item == currentItemIndex+1 {
                
                attributes.zIndex = -1
                attributes.transform = CGAffineTransformMakeTranslation(visibleRect.origin.x - self.itemSize.width * CGFloat(attributes.indexPath.item), 0)
            }
        }
    }
    
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let layoutCollectionView = self.collectionView else {
            return CGPointZero
        }
        
        let lastContentOffset = layoutCollectionView.contentSize.width - itemSize.width
        print(lastContentOffset)
        
        if velocity.x.isZero {
        
            let remainder = self.itemSize.width - (proposedContentOffset.x % self.itemSize.width)
            
            if remainder < self.itemSize.width/2 {
            
                let x = min(ceil(proposedContentOffset.x/self.itemSize.width) * self.itemSize.width, lastContentOffset)
                
                return CGPointMake(x, proposedContentOffset.y)

            } else {
            
                let x = min(floor(proposedContentOffset.x/self.itemSize.width) * self.itemSize.width, lastContentOffset)
                
                return CGPointMake(x, proposedContentOffset.y)
            }
            
        } else if velocity.x.isSignMinus {
            
            //Left to Right Swipe
        
            let x = floor(layoutCollectionView.contentOffset.x/self.itemSize.width) * self.itemSize.width
            
            return CGPointMake(x, proposedContentOffset.y)
            
        } else {
            
            //Right to Left Swipe
            
            let x = ceil(layoutCollectionView.contentOffset.x/self.itemSize.width) * self.itemSize.width

            return CGPointMake(x, proposedContentOffset.y)
        }
        
    }

    
//    func applyLayoutAttributes(attributes : GSCollectionViewLayoutAttributes, forVisibleRect visibleRect : CGRect) {
//
//        let ACTIVE_DISTANCE = CGFloat(100)
//        let TRANSLATE_DISTANCE = CGFloat(100)
//        let ZOOM_FACTOR = CGFloat(0.2)
//        let FLOW_OFFSET = CGFloat(40)
//        let INACTIVE_GREY_VALUE = CGFloat(0.6)
//        
//        if attributes.representedElementKind != nil {  return  }
//        
//        // Calculate the distance from the center of the visible rect to the center of the attributes. Then normalize it so we can compare them all. This way, all items further away than the active get the same transform.
//        
//        let distanceFromVisibleRectToItem : CGFloat = CGRectGetMidX(visibleRect) - attributes.center.x
//        
//        let normalizedDistance : CGFloat = distanceFromVisibleRectToItem / ACTIVE_DISTANCE
//        
//        // Handy for use in making a number negative selectively 
//        
//        let isLeft = distanceFromVisibleRectToItem > 0
//        
//        // Default values
//        
//        var transform = CATransform3DIdentity
//        var maskAlpha = CGFloat(0.0)
//        
//        if fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE {
//            
//            transform = CATransform3DTranslate(CATransform3DIdentity,
//            (isLeft ? -FLOW_OFFSET : FLOW_OFFSET) * abs(distanceFromVisibleRectToItem/TRANSLATE_DISTANCE),
//            0,
//            (1 - fabs(normalizedDistance)) * 40000 + (isLeft ? 200 : 0)
//            )
//
//            transform.m34 = -1/(CGFloat(4.6777) * self.itemSize.width)
//        
//            let zoom = 1 + ZOOM_FACTOR * (1 - abs(normalizedDistance))
//            
//            transform = CATransform3DRotate(transform,
//                
//                (isLeft ? 1 : -1) * fabs(normalizedDistance) * CGFloat(45 * M_PI/180),
//                
//                0, 1, 0)
//        
//            transform = CATransform3DScale(transform, zoom, zoom, 1)
//        
//            attributes.zIndex = 1
//            
//            let ratioToCenter = (ACTIVE_DISTANCE - fabs(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE
//
//            // Interpolate between 0.0f and INACTIVE_GREY_VALUE
//            maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter * (-INACTIVE_GREY_VALUE)
//        
//        } else {
//        
//            transform.m34 = -1/(CGFloat(4.6777) * self.itemSize.width)
//            transform = CATransform3DTranslate(transform, (isLeft ? -FLOW_OFFSET : FLOW_OFFSET), 0, 0)
//            transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * CGFloat(45 * M_PI/180), 0, 1, 0)
//            
//            attributes.zIndex = 0
//
//            maskAlpha = INACTIVE_GREY_VALUE
//        }
//        
//        attributes.transform3D = transform
//        
//        attributes.shouldRasterize = true
//        attributes.maskingValue = maskAlpha
//    }

    
//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        var offsetAdjustment = CGFloat.max
//        let horizontalCenter = proposedContentOffset.x + (self.collectionView!.bounds.width/2.0)
//            
//        let proposedRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView!.bounds.width, self.collectionView!.bounds.height)
//    
//        let array = self.layoutAttributesForElementsInRect(proposedRect)!
//            
//        for layoutAttributes in array {
//        
//            if layoutAttributes.representedElementCategory != UICollectionElementCategory.Cell {  continue  }
//
//            let itemHorizontalCenter = layoutAttributes.center.x
//            
//            if fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment) {
//                offsetAdjustment = itemHorizontalCenter - horizontalCenter
//            }
//        }
//            
//        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y)
//    }

}
















