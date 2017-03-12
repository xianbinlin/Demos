//
//  HorizontalItem.swift
//  DemoCartCollectionView
//
//  Created by xianbin lin on 2017/3/12.
//  Copyright © 2017年 lin. All rights reserved.
//

import UIKit
import AVFoundation
class HorizontalItem: UICollectionViewCell {

    // TODO: create a player for each cell may cause performance issue, need to check
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
 
    @IBOutlet weak var imageView: UIImageView!



}
