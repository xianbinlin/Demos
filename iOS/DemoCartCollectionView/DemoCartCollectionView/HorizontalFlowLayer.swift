//
//  HorizontalFlowLayer.swift
//  DemoCartCollectionView
//
//  Created by xianbin lin on 2017/3/11.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import UIKit

class HorizontalFlowLayer: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        self.scrollDirection = UIDevice.current.orientation.isLandscape ? .horizontal : .vertical
        self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func prepare() {
//        // call when cell reuseed, before pass to index
        //  often use to clear cell state
//    }
    
    /**
     if true, when frame change, call prepareLayout and layoutAttributesForElementsInRect
     get property of cell in Rect
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /**
     calculate all cells in rect and return new attributes
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // get all cells in rect, but we only change the attributes for visiable rect in screen.
        // unwrap super's attributes
        guard let superArray = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // copy items
        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        // visiable rect
        let visiableRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        
        var distanceToCenter:CGFloat
        var normalizeDistance:CGFloat
        var activeDistance:CGFloat //distance to center < activeDistance will active scale transform
        let scaleFactor:CGFloat = 0.2
        
        for attribute in attributes {
            if attribute.frame.intersects(visiableRect) {
                attribute.alpha = 0.5
                
                if self.scrollDirection == .horizontal {
                    activeDistance = 320
                    distanceToCenter = visiableRect.midX - attribute.center.x
                    normalizeDistance = distanceToCenter / activeDistance
                } else {
                    activeDistance = 100
                    distanceToCenter = visiableRect.midY - attribute.center.y
                    normalizeDistance = distanceToCenter / activeDistance
                }
                
                if (abs(distanceToCenter) < activeDistance) {
                    let zoom:CGFloat = 1 + scaleFactor * (1 - abs(normalizeDistance) )
                    attribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attribute.zIndex = 1
                    attribute.alpha = 1.0
                }
            }
        }
        
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        ////  |-------[-------]-------|
        ////  |scrroll|visiable|rest|
        // when we scroll to right,

        var center:CGFloat
        var targetRect:CGRect
        
        // CGFloat centerX = self.collectionView.center.x;
        //  screen center
        
        if self.scrollDirection == .horizontal {
            center = proposedContentOffset.x + (collectionView!.bounds.width/2.0)
            targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        } else {
            center = proposedContentOffset.y + (collectionView!.bounds.height/2.0)
            targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
        }
        
        guard let superArray = super.layoutAttributesForElements(in: targetRect) else { return proposedContentOffset }
        
        // copy items
        guard let attributes = NSArray(array: superArray, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return proposedContentOffset }
        
        
        var itemCenter:CGFloat
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        var newPoint:CGPoint = proposedContentOffset
        for attribute in attributes {
            
            if self.scrollDirection == .horizontal{
                itemCenter = attribute.center.x
                if (abs(itemCenter - center) < abs(offsetAdjustment)) {
                    // find the smallest offset of the middle item
                    offsetAdjustment = itemCenter - center;
                }
                newPoint = CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
            } else {
                itemCenter = attribute.center.y
                if (abs(itemCenter - center) < abs(offsetAdjustment)) {
                    offsetAdjustment = itemCenter - center;
                }
                newPoint = CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment)
                
            }
        }
        return newPoint
    }
    


    

}
