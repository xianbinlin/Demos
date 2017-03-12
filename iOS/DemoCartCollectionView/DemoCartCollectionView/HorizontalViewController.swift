//
//  HorizontalViewController.swift
//  DemoCartCollectionView
//
//  Created by xianbin lin on 2017/3/11.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import UIKit

 
class HorizontalViewController: UIViewController {
    
    
    @IBOutlet var horizontalCollectionView: HorizontalCollectionView!{
        didSet{
            print("horizontalCollectionView")
//          horizontalCollectionView.register(HorizontalItem.self, forCellWithReuseIdentifier: String(describing: HorizontalItem.self))
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var itemResources:[ItemModel] = [ItemModel]()
    
    override func viewDidLoad() {
        let videoAry:[String] = ["video1","video2","video3","video4","video5"]
        let imageAry:[String] = ["img_template_1","img_template_2","img_template_3","bg2","bg3"]
        
        for i in 0..<videoAry.count{
            itemResources.append( ItemModel(imagePath: imageAry[i], videoPath: videoAry[i]) )
        }
        
        horizontalCollectionView.setup(items: itemResources)

        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("indexL",self.horizontalCollectionView.currentCellIndex)
        if self.horizontalCollectionView.flowlayout.scrollDirection == .horizontal {
            self.horizontalCollectionView.scrollToItem(at: self.horizontalCollectionView.currentCellIndex as IndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        } else {
            self.horizontalCollectionView.scrollToItem(at: self.horizontalCollectionView.currentCellIndex as IndexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
        
        self.horizontalCollectionView.reloadData()
        self.horizontalCollectionView.flowlayout.invalidateLayout()
        self.horizontalCollectionView.setNeedsDisplay()
    }
    

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.horizontalCollectionView.flowlayout.scrollDirection = .horizontal
            self.horizontalCollectionView.flowlayout.minimumLineSpacing = 20
            
            
        } else {
            self.horizontalCollectionView.flowlayout.scrollDirection = .vertical
            self.horizontalCollectionView.flowlayout.minimumLineSpacing = 20
            
            
        }
        
        self.horizontalCollectionView.frame.size = size
        self.horizontalCollectionView.reloadData()
        self.horizontalCollectionView.flowlayout.invalidateLayout()
        self.horizontalCollectionView.setNeedsDisplay()
    }


}
