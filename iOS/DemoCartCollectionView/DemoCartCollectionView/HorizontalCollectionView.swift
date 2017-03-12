//
//  HorizontalCollectionView.swift
//  DemoCartCollectionView
//
//  Created by xianbin lin on 2017/3/11.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class HorizontalCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var items:[ItemModel] = [ItemModel]()
    var flowlayout = HorizontalFlowLayer()
    


    /// for create a loop collection view, we create 100 section repeat, and set start position to 50 section
    var currentCellIndex :IndexPath =  IndexPath(row: 0, section: 50)
    
    
    func setup(items:[ItemModel]){
        self.items = items
        self.collectionViewLayout = flowlayout
        self.dataSource  = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.decelerationRate = 100
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        var center:CGFloat
        if self.flowlayout.scrollDirection == .horizontal {
            center = scrollView.contentOffset.x + (self.bounds.width/2.0)
        } else {
            center = scrollView.contentOffset.y + (self.bounds.height/2.0)
        }
        
        var minDistance:CGFloat = 10000
        var centerCell:HorizontalItem?
        var distance:CGFloat
        for cell in self.visibleCells {
            
            if self.flowlayout.scrollDirection == .horizontal {
                distance = abs(cell.center.x - center)
            } else {
                distance = abs(cell.center.y - center)
            }
            
            if  distance < minDistance {
                minDistance = distance
                centerCell = cell as? HorizontalItem
            }
        }
        if centerCell != nil {
            currentCellIndex = self.indexPath(for: centerCell!)!
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        let cell = self.cellForItem(at: currentCellIndex)
        cell?.layer.borderColor = UIColor.white.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        if self.flowlayout.scrollDirection == .horizontal {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: true)
        }
        
        if currentCellIndex == indexPath {
//            willSelected = !selected
            return
        } else {
            currentCellIndex = indexPath
//            willSelected = false
//            willSelected = true
        }
        
//        _cycleDelegate?.didSelectIndexCollectionViewCell(indexPath.row)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        selected = willSelected
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section != 0 || section != 99 {
            if self.flowlayout.scrollDirection == .horizontal {
                return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            } else {
                return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            }
        }
        
        
        let itemCount:Int = collectionView.numberOfItems(inSection: section)
        let firstIndexPath = IndexPath(item: 0, section: section)
        let firstSize:CGSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: firstIndexPath)
        let lastIndexPath = IndexPath(item: itemCount - 1, section: section)
        let lastSize:CGSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: lastIndexPath)
        
        
        if self.flowlayout.scrollDirection == .horizontal {
            return UIEdgeInsets(top: 0, left: (collectionView.bounds.size.width - firstSize.width)/2, bottom: 0, right:  (collectionView.bounds.size.width - lastSize.width)/2)
        } else {
            return UIEdgeInsets(top: (collectionView.bounds.size.height - firstSize.height)/2, left: 0, bottom: (collectionView.bounds.size.height - lastSize.height)/2, right:  0)
        }
        
    }


}



// ###################################################################
// MARK: *UICollectionViewDataSource*
// ###################################################################
extension HorizontalCollectionView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // repeat section 100 time to make a loop cart collectionView
        return items.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HorizontalItem", for: indexPath) as! HorizontalItem
            // first time, init cell
            
            let image:UIImage? = UIImage(named: items[indexPath.row].imagePath)
        
            cell.imageView?.image = image
            
            if currentCellIndex == indexPath {
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 5
                cell.layer.borderColor = UIColor.yellow.cgColor
            }
        
        return cell
        
    }

}




// ###################################################################
// MARK: *UICollectionViewDelegateFlowLayout*
// ###################################################################
extension HorizontalCollectionView{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizeScale:CGFloat
        var _itemHeight:CGFloat = 0.0
        var _itemWidth:CGFloat = 0.0
        
        
        if self.flowlayout.scrollDirection == .horizontal {
            sizeScale = 0.7
            _itemHeight = collectionView.frame.size.height * sizeScale
            _itemWidth = _itemHeight*16/9
        } else {
            sizeScale = 0.8
            _itemWidth = collectionView.frame.size.width * sizeScale
            _itemHeight = _itemWidth*9/16
        }
        
        return CGSize(width: _itemWidth, height: _itemHeight)
    }
    
}
